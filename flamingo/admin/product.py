# -*- coding: utf-8 -*-

import os
import json
import psycopg2
import math

from flask import request, render_template, redirect, flash
from flask_login import login_required

from flamingo import app, sql
from flamingo.core.common import ornull, DecimalEncoder, return_json_ok, return_json_error
from flamingo.core.config import get_image_path, get_abs_image_path
from flamingo.model.product import Product, Products
from flamingo.model.category import Categories
from flamingo.model.manufacturer import Manufacturers
from flamingo.model.image import Image
from flamingo.model.relation import Relations, Relation
from flamingo.model.attribute_category import AttributeCategories
from flamingo.model.attribute import AttributeValue

@app.route('/admin/products')
@login_required
def admin_products():
    name = ornull(request.args.get('name'))
    category_id = ornull(request.args.get('category_id'))
    categories = Categories.get(None, admin=True)
    page = request.args.get('page', 1)

    products = Products.get_admin(category_id, name, 'p.sku', 'asc', page)
    pages_count = math.ceil(Products.get_admin_products_count(category_id, name) / 20)

    return render_template('admin/products.html', products=products, name=name, categories=categories,
        pages_count=pages_count)

@app.route('/admin/product-search', methods=['GET'])
@login_required
def admin_product_search():
    products = Products.search(request.args.get('name'))
    return render_template('admin/include/product-search-results.html', products=products)

@app.route('/admin/product/<int:parent_id>/accessory-add/<int:child_id>', methods=['POST'])
@login_required
def admin_accessory_add(parent_id, child_id):
    relation_id = Relation.set(parent_id, child_id, 'accessory')

    return return_json_ok({'id': relation_id})

@app.route('/admin/product/<int:product_id>/accessory-del/<int:relation_id>', methods=['POST'])
@login_required
def admin_accessory_del(product_id, relation_id):
    deleted_id = Relation.delete(relation_id)

    return return_json_ok({'id': deleted_id})

@app.route('/admin/product/<int:product_id>/accessories', methods=['GET'])
@login_required
def admin_product_accessories(product_id):
    aks = Relations.get(product_id, 'accessory')
    return render_template('admin/include/product-accessories.html', aks=aks)

@app.route('/admin/product/<product_id>/set_price', methods=['POST'])
@login_required
def admin_set_price(product_id):
    price = request.form.get('price')

    result = sql.get_value('select admin.set_price(%s, %s)', (product_id, price))

    resp = app.response_class(
        response=json.dumps(result, cls=DecimalEncoder),
        status=200,
        mimetype='application/json'
    )
    return resp

@app.route('/admin/product/<product_id>/set_previous_price', methods=['POST'])
@login_required
def admin_set_previous_price(product_id):
    previous_price = request.form.get('previous_price')
    if previous_price == '':
        previous_price = None

    result = sql.get_value('select admin.set_previous_price(%s, %s)', (product_id, previous_price))

    resp = app.response_class(
        response=json.dumps(result, cls=DecimalEncoder),
        status=200,
        mimetype='application/json'
    )
    return resp

@app.route('/admin/product/<product_id>/set_available', methods=['POST'])
@login_required
def admin_set_available(product_id):
    available = request.form.get('available')

    result = sql.get_value('select admin.set_available(%s, %s)', (product_id, available))

    resp = app.response_class(
        response=json.dumps(result, cls=DecimalEncoder),
        status=200,
        mimetype='application/json'
    )
    return resp

@app.route('/admin/product/', methods=['GET'])
@app.route('/admin/product/<int:id>', methods=['GET'])
@login_required
def admin_product(id=None):
    product = Product.admin_get(id)
    images = Product.get_images(id, 200)
    aks = Relations.get(id, 'accessory')

    return render_template('admin/product.html', product=product, images=images,
                           categories=Categories.get(None, admin=True),
                           manufacturers=Manufacturers.get(), aks=aks)

@app.route('/admin/product', methods=['POST'])
@login_required
def admin_product_update():
    product = {'name': request.form.get('name'),
               'description': ornull(request.form.get('description').strip()),
               'price': ornull(request.form.get('price')),
               'available': request.form.get('available'),
               'is_visible': request.form.get('is_visible') == 'on',
               'category_id': request.form.get('category_id'),
               'manufacturer_id': request.form.get('manufacturer_id'),
               'sku': request.form.get('sku'),
               'previous_price': ornull(request.form.get('previous_price')),
               'sef_name': ornull(request.form.get('sef_name')),
               'gtin': ornull(request.form.get('gtin'))}

    id = ornull(request.form.get('id'))
    returned_id = Product.update(id, product)

    if returned_id is None:
        flash('Product not found or could not be updated')

    return redirect('/admin/product/%s' % returned_id)

@app.route('/admin/product/<int:id>/image/upload', methods=['POST'])
@login_required
def admin_product_image_upload(id):
    uploaded_file = request.files['file']

    ext = uploaded_file.filename.split('.')[-1]

    if not Image.is_valid_filename(uploaded_file.filename):
        flash('Invalid file extension')
        return redirect('/admin/product/%s' % id)

    basename, index = Product.get_new_image_name(id)
    local_filename = os.path.join(get_abs_image_path(), 'product', '%s.%s' % (basename, ext,))
    uploaded_file.save(local_filename)

    Image.update_image(local_filename)
    Product.add_image(id, index, '/static/image/product/%s.%s' % (basename, ext,))

    return redirect('/admin/product/%s' % id)

@app.route('/admin/product/<int:id>/image/delete', methods=['POST'])
@login_required
def admin_product_image_delete(id):
    url = Product.delete_image(id, int(request.form.get('image_id')))

    if not Image.is_used(url):
        Image.remove(url)

    resp = app.response_class(
        response=json.dumps({'status': 'ok'}, cls=DecimalEncoder),
        status=200,
        mimetype='application/json'
    )

    return resp

@app.route('/admin/product/<int:product_id>/move_picture', methods=['POST'])
@login_required
def admin_product_move_picture(product_id):

    data = request.get_json()
    id = data['id']
    direction = data['direction']

    result = sql.get_value('select admin.move_picture(%s, %s, %s)', (product_id, id, direction,))

    if result > 0:
        return return_json_ok()
    else:
        return return_json_error('Could not move image')


@app.route('/admin/product/<int:id>/delete', methods=['POST'])
@login_required
def admin_product_delete(id):
    try:
        result = Product.delete(id)
        flash('Товар удален', 'info')
        return redirect('/admin/products')
    except psycopg2.IntegrityError as e:
        flash('Ошибка при удалении товара: %s' % str(e), 'error')
        return redirect('/admin/product/%s' % id)

@app.route('/admin/product/<int:id>/attributes')
@login_required
def admin_product_attributes(id):
    product = Product.admin_get(id)
    attributes = Product.get_attributes(id)
    for_attributes = [a['id'] for a in attributes]
    attribute_categories=AttributeCategories.get(for_attributes)

    return render_template('admin/product-attributes.html', product=product, attributes=attributes,
                           attribute_categories=attribute_categories)

@app.route('/admin/product/<int:id>/attribute-value-set', methods=['POST'])
@login_required
def admin_attribute_value_set(id):
    data = request.get_json()

    result = AttributeValue.set(data['sku'], data['attribute_category'], data['attribute_name'],
                                data['value'], create_if_not_exists=True)

    return return_json_ok({'result': result})
