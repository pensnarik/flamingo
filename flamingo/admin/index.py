# -*- encoding: utf-8 -*-

from flask import render_template
from flask_login import login_required

from flamingo import app, sql
from flamingo.model.image import Image

def _get_orders():
    return sql.get_rows('select * from web.get_orders()')

@app.route('/admin')
@login_required
def admin_index():
    return render_template('admin/index.html', orders=_get_orders())

@app.route('/update-image-cache')
@login_required
def update_image_cache():
    Image.update_cache()
    return 'OK'