# *-* coding: utf-8 -*-

# Methods to deal with product: set/get price and availability, name, etc.

import os
import json
import base64

from flask import request
from flamingo import app, sql

from flamingo.model import Product, ProductViewStat
from flamingo.model.image import Image

from flamingo.core.api import api_auth_required, api_return, api_error

@app.route('/api/product/<string:sku>/sort_order/<int:sort_order>', methods=['POST'])
@api_auth_required
def api_product_sort_order_set(sku, sort_order):
    id = Product.get_id(sku)
    if id is None:
        return api_error(404, 'Product not found')

    result = sql.get_value('select api.product_sort_order_set(%s, %s)',
                           (sku, sort_order))

    return api_return({'status': 'ok', 'result': 'result'})

@app.route('/api/product/<string:sku>/set_exported', methods=['POST'])
@api_auth_required
def api_product_set_exported(sku):
    id = Product.get_id(sku)
    if id is None:
        return api_error(404, 'Product not found')

    data = request.get_json()

    if data is None or 'is_exported' not in data:
        return api_error(400, 'Bad params')

    try:
        sql.get_value('select api.module_product_set(%s, %s, %s)',
                      (data['module'], id, data['is_exported']))
        return api_return({'status': 'ok'})
    except:
        return api_error(500, 'Could not update name')

@app.route('/api/set_price', methods=['POST'])
@api_auth_required
def api_set_price():
    data = request.get_json()

    if data is None or 'sku' not in data or 'price' not in data:
        return api_error(400, 'Bad params')

    sql.get_value('select api.set_price(%s, %s)', (data['sku'], data['price']))

    return api_return({'status': 'ok'})

@app.route('/api/set_available', methods=['POST'])
@api_auth_required
def api_set_available():
    data = request.get_json()

    if data is None or 'sku' not in data or 'available' not in data:
        return api_error(400, 'Bad params')

    sql.get_value('select api.set_available(%s, %s)', (data['sku'], data['available']))

    return api_return({'status': 'ok'})

@app.route('/api/set_available_bulk', methods=['POST'])
@api_auth_required
def api_set_available_bulk():
    data = request.get_json()

    result = sql.get_rows('select * from api.set_available_bulk(%s)', (json.dumps(data),))

    return api_return({'status': 'ok', 'data': result})

@app.route('/api/set_name', methods=['POST'])
@api_auth_required
def api_set_name():
    data = request.get_json()

    if data is None or 'sku' not in data or 'name' not in data:
        return api_error(400, 'Bad params')

    sql.get_value('select api.set_name(%s, %s)', (data['sku'], data['name']))

    return api_return({'status': 'ok'})

@app.route('/api/get_product_id/<string:sku>', methods=['GET'])
@api_auth_required
def api_get_product_id(sku):
    id = sql.get_value('select api.get_product_id(%s)', (sku,))
    return api_return({'status': 'ok', 'id': id})

@app.route('/api/product/<sku>/set_name', methods=['POST'])
@api_auth_required
def api_product_set_name(sku):
    id = Product.get_id(sku)
    if id is None:
        return api_error(404, 'Product not found')

    data = request.get_json()

    if data is None or 'name' not in data:
        return api_error(400, 'Bad params')

    result = sql.get_value('select api.set_product_name(%s, %s)', (id, data['name']))

    if result == 0:
        return api_return({'status': 'ok'})
    else:
        return api_error(500, 'Could not update name')

@app.route('/api/product/<sku>/set_visibility', methods=['POST'])
@api_auth_required
def api_product_set_visibility(sku):
    if Product.get_id(sku) is None:
        return api_error(404, 'Product not found')

    data = request.get_json()

    if data is None or 'is_visible' not in data:
        return api_error(400, 'Bad params')

    is_visible = data.get('is_visible') in ('True', 'true', '1')

    result = sql.get_value('select api.set_visibility(%s, %s)', (sku, is_visible))
    print(result)

    if result == 0:
        return api_return({'status': 'ok'})
    else:
        return api_error(500, 'Could not update visibility')

@app.route('/api/product/<string:sku>/attributes', methods=['POST'])
@api_auth_required
def api_product_attributes_set(sku):
    attrs_updated = sql.get_value('select api.attributes_update(%s, %s, %s)',
                                  (sku, json.dumps(request.get_json(), ensure_ascii=False), True,))
    return api_return({'status': 'ok', 'attributes_updated': attrs_updated})

def extract_images(product_id, images):
    for image in images:
        filename = Image.generate_filename('product', product_id, image['url'].split('.')[-1], image['priority'])
        fullname = Image.get_abs_path(filename)
        with open(fullname, 'wb') as f:
            f.write(base64.b64decode(image['data'].encode('utf-8')))
            Image.update_image(fullname)
            Product.add_image(product_id, image['priority'], filename)

@app.route('/api/product/<string:sku>/set', methods=['POST'])
@app.route('/api/product/set', methods=['POST'])
@api_auth_required
def api_product_set(sku=None):
    ''' Load a product into the database.
    WARNING. This method removes all the images for the product,
    even if ones are not exist in the source JSON data.
    '''
    data = request.get_json()
    if sku is None:
        sku = data['product']['sku']

    images = data['product']['images'].copy()
    del data['product']['images']

    product_id = sql.get_value('select api.product_set(%s, %s, %s)',
                               (sku, json.dumps(data, ensure_ascii=False), True,))

    # Remove all existing images for the product
    for image in Product.get_images(product_id):
        url = Product.delete_image(product_id, image['id'])

        if not Image.is_used(url):
            Image.remove(url)

    extract_images(product_id, images)

    if 'diagrams' in data['product']:
        Product.diagrams_set(product_id, json.dumps(data['product']['diagrams'], ensure_ascii=False))

    if 'groups' in data['product']:
        for group in data['product']['groups']:
            Product.product_group_set(product_id, group['mnemonic'], group['name'])

    return api_return({'status': 'ok', 'result': product_id})

@app.route('/api/product/<string:sku>', methods=['GET'])
@api_auth_required
def api_product_get(sku):
    res = sql.get_value('select api.product_json(%s)', (sku,))
    res['images'] = []
    product_id = Product.get_id(sku)
    for image in Product.get_images(product_id):
        path = Image.get_abs_path(image['url'])

        if os.path.exists(path):
            with open(path, 'rb') as f:
                encoded_image = base64.b64encode(f.read())
            res['images'].append({'url': image['url'], 'data': encoded_image.decode('utf-8'),
                                  'priority': image['priority']})

    return api_return({'status': 'ok', 'product': res})

@app.route('/api/product_view_stat/<string:day>')
@app.route('/api/product_view_stat')
@api_auth_required
def api_product_view_stat(day=None):
    ProductViewStat.get(day)
    return api_return({'status': 'ok'})
