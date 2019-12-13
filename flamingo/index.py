import re
import os
import json
import math

from flask import render_template, render_template_string, g, request, make_response, abort

from flamingo import app, sql
from flamingo.core.config import get_parameter_value
from flamingo.model.category import Categories, Category
from flamingo.model import Product, Products, ProductGroup, Image

def get_breadcrumbs(parent_id):
    query = 'select * from web.get_breadcrumbs(%s) order by level desc'
    return sql.get_rows(query, (parent_id,))

def add_product_to_cart(secret, product_id):
    return sql.get_row('select * from web.add_product_to_cart(%s, %s)', (secret, product_id,))

def has_category_products(category_id):
    return sql.get_value('select web.has_category_products(%s)', (category_id,))

def filters_from_args(args, **selected):
    default_values = {'products_on_page': 50, 'page': 1, 'sort': 'sort_order;asc', 'limit': 300}
    filters = {}
    attributes = []

    for k in args.keys():
        if k.startswith('attr_'):
            attributes.append({'attribute_id': int(k.split('_')[1]), 'value': args[k]})
        else:
            filters.update({k: args[k]})
    for k in default_values.keys():
        if k not in filters:
            filters.update({k: default_values.get(k)})
    for k in selected.keys():
        filters.update({k: selected[k]})

    if 'products_per_page' in request.cookies:
        filters.update({'limit': int(request.cookies['products_per_page'])})

    filters.update({'order_col': filters['sort'].split(';')[0],
                    'order_dir': filters['sort'].split(';')[1],
                    'filters': json.dumps(attributes, ensure_ascii=False)})

    return filters

@app.route('/', methods=['GET'])
def index():
    filters = filters_from_args(request.args, category_id=None,
                                group_id=ProductGroup.get_id('popular'))
    products = Products.list_get(filters)
    products_count = Products.list_get_count(filters)

    pages_count = math.ceil(products_count / int(filters['limit']))

    return render_template('index.html', level=0, products=products, pages=range(1, pages_count),
                           categories=Categories.get(None))

@app.route('/search', methods=['GET'])
def search_products():
    filters = filters_from_args(request.args)
    products = Products.list_get(filters)
    products_count = Products.list_get_count(filters)
    pages_count = math.ceil(products_count / int(filters.get('limit')))

    return render_template('search.html', level=0, products=products, pages=range(1, pages_count),
                           products_count=products_count)

@app.route('/group/<id>', methods=['GET'])
@app.route('/group/<id>/', methods=['GET'])
def group(id):
    group_name = ProductGroup.get_name(id)

    if group_name is None:
        return abort(404)

    filters = filters_from_args(request.args, category_id=None, group_id=id)

    products = Products.list_get(filters)
    products_count = Products.list_get_count(filters)

    pages_count = math.ceil(products_count / int(filters['limit']))

    category = {'name': group_name, 'id': 0}

    return render_template('products.html',
                           category=category,
                           category_id=0,
                           products=products,
                           products_count=products_count,
                           categories=Categories.get(0),
                           limit=filters.get('limit'),
                           pages=range(1, pages_count))

@app.route('/category/<id>', methods=['GET'])
@app.route('/category/<id>/', methods=['GET'])
def category(id):
    if not re.match('^\d+$', id):
        category_id = sql.get_value('select web.get_category_by_sef(%s)', (id,))
        if category_id is None:
            return abort(404)
    else:
        if Category.get(id) is None:
            return abort(404)

        category_id = int(id)

    include_subcategories = not (get_parameter_value('HasCategories') == 'True')

    breadcrumbs = get_breadcrumbs(category_id)
    level = max(i['level'] for i in breadcrumbs)
    category = sql.get_row('select * from web.get_category(%s)', (category_id,))

    filters = filters_from_args(request.args, category_id=category_id)
    products = Products.list_get(filters, include_subcategories)
    products_count = Products.list_get_count(filters, include_subcategories)
    pages_count = math.ceil(products_count / int(filters.get('limit')))

    # Для того, чтобы определить, отображать шаблон с товарами или категориями
    # нужно понять, есть ли у этой категории дочерние категории. В таком случае
    # будет выбран правильный шаблон даже если в отображаемой категории
    # нет товаров
    if get_parameter_value('HasCategories') == 'True':
        if Category.has_childs(category_id):
            template = 'category.html'
        else:
            template = 'products.html'
    else:
        template = 'products.html'

    return render_template(template, category=category, breadcrumbs=breadcrumbs,
                           products=products, categories=Categories.get(category_id),
                           category_path=Category.path(category_id), products_count=products_count,
                           limit=filters.get('limit'), pages=range(1, pages_count),
                           level=level, category_id=category_id)

@app.route('/info/<string:page>')
def infopage(page):
    content = sql.get_value('select web.infopage_get(%s)', (page,))
    if content is None:
        return abort(404)
    sql.execute('select web.infopage_views_inc(%s)', (page,))
    return render_template_string(content)

@app.route('/check-images')
def check_images():
    non_existsent_images = []
    for image in sql.get_rows('select * from admin.get_all_images()'):
        print(image)
        abs_path = Image.get_abs_path(image['url'])
        if not os.path.exists(abs_path):
            non_existsent_images.append(abs_path)
            if request.args.get('action') == 'fix':
                Product.delete_image(image['product_id'], image['id'])

    if len(non_existsent_images) == 0:
        return 'All images are OK'
    else:
        return '<br>'.join(non_existsent_images)
