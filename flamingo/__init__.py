import os
import json
import configparser
import psycopg2
import psycopg2.extras
import psycopg2.extensions
import time
from math import floor
from urllib.parse import parse_qs, urlencode

import jinja2
from flask import Flask, render_template, Response, request
from flask_login import current_user
from flask import g

config = configparser.ConfigParser()
config.read('flamingo.config')

app = Flask(__name__)
custom_loader = jinja2.ChoiceLoader([
    jinja2.FileSystemLoader(os.path.join(app.root_path, 'templates/theme/%s') % config.get('main', 'theme')),
    jinja2.FileSystemLoader(os.path.join(app.root_path, 'templates/themeless'))
    ])
app.jinja_loader = custom_loader

from flamingo import index, cart, order, diagram, product, sql, feedback, sale, \
    product_list, leadgen, warranty
from flamingo.admin import index, login, order, translation, product, category, infopage, feedback, \
    banners, snippet, report
from flamingo.core import api
from flamingo.core.api import category, product
from flamingo.cart import _get_cart_totals
from flamingo.model.category import Categories
from flamingo.model.menu import Menu
from flamingo.model.image import Image
from flamingo.module import blanks
import flamingo.module

flamingo.module.load_modules()

@app.before_request
def get_db():
    retry_count = 10

    if not hasattr(g, 'conn'):
        while retry_count > 0:
            try:
                g.conn = psycopg2.connect(config.get('db', 'dsn'))
                g.conn.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
                return
            except psycopg2.OperationalError:
                print("Could not connect to database, retry_count = %s" % retry_count)
                time.sleep(10)
                retry_count = retry_count - 1
            raise Exception("Could not establish connection to database")

@app.teardown_appcontext
def teardown(exception):
    if hasattr(g, 'conn'):
        g.conn.close()

@app.context_processor
def inject_now():
    return {'now': floor(time.time())}

@app.context_processor
def inject_config():
    return {'config': sql.get_value('select web.get_config()')}

@app.context_processor
def inject_menu():
    return {'menu': sql.get_rows('select * from web.get_menu(null)')}

@app.context_processor
def inject_cart():
    if 'customer_id' not in request.cookies:
        totals = {'quantity': 0, 'amount': 0.0}
    else:
        totals = _get_cart_totals(request.cookies['customer_id'])
    return {'cart': totals}

@app.context_processor
def inject_banners():
    return {'banners': sql.get_rows('select * from web.get_banners()')}

@app.context_processor
def inject_top_links():
    return {'top_links': sql.get_rows("select * from web.get_menu('top')")}

@app.context_processor
def inject_top_categories():
    return {'top_categories': Categories.get(None)}

@app.context_processor
def inject_categories_json():
    return {'categories_json': Menu.get_json()}

@app.context_processor
def inject_admin_menu():
    if current_user is not None:
        return {'admin_menu': sql.get_rows('select * from admin.get_menu()')}
    else:
        return None

@app.context_processor
def inject_snippets():
    return {'snippets': sql.get_rows('select * from web.snippets_get()')}

@app.context_processor
def inject_filters():
    return {'custom_filters': sql.get_value('select web.get_filters()')}

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404

@app.errorhandler(403)
def access_denied(e):
    return render_template('403.html'), 403

@app.route('/403.html')
def access_dedined2():
    return render_template('403.html'), 403

@app.route('/robots.txt', methods=['GET'])
def robots():
    return Response(render_template('system/robots.txt'), mimetype='text/plain')

def replace_arg(path, arg, value):
    uri = path.replace(';', '%3B').split('?')[-1]
    args = {k: ','.join(v) for k, v in parse_qs(uri).items()}
    args.update({arg: value})
    return urlencode(args).replace('%3B', ';')

def is_filter_enabled(args, attribute_id, value):
    uri = args.replace(';', '%3B').split('?')[-1]
    for item in parse_qs(uri).items():
        if item[0] == 'attr_%s' % attribute_id and value in item[1][0].split(','):
            return True
    return False

app.jinja_env.filters['replace_arg'] = replace_arg
app.jinja_env.filters['is_filter_enabled'] = is_filter_enabled
