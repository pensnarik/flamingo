# *-* coding: utf-8 -*-

# flamingo category API methods

import os
import json
import base64

from flask import request

from flamingo import app, sql
from flamingo.model.image import Image
from flamingo.core.api import api_auth_required, api_return

@app.route('/api/category/<int:id>', methods=['GET'])
@api_auth_required
def api_category_get(id):
    res = sql.get_value('select api.category_json_by_id(%s)', (id,))
    if res['image']:
        path = Image.get_abs_path(res['image'])

        if os.path.exists(path):
            with open(path, 'rb') as f:
                encoded_image = base64.b64encode(f.read())
                res['image_data'] = encoded_image.decode('utf-8')

    return api_return({'status': 'ok', 'category': res})

@app.route('/api/category', methods=['POST'])
@api_auth_required
def api_category_set():
    data = request.get_json()['category']

    category_id = sql.get_value('select api.category_get(%s, %s)', (data['name'], True,))
    category = sql.get_row('select * from web.get_category(%s)', (category_id,))

    # Удаление существующего изображения
    if category['image']:
        print(Image.get_abs_path(category['image']))
        if os.path.exists(Image.get_abs_path(category['image'])):
            Image.remove(category['image'])

    if data['image']:
        fullname = Image.get_abs_path(data['image'])
        with open(fullname, 'wb') as f:
            f.write(base64.b64decode(data['image_data'].encode('utf-8')))
            sql.get_value('select api.category_update_image(%s, %s)', (category_id, data['image'],))

    return api_return({'status': 'ok', 'result': category_id})

@app.route('/api/categories', methods=['GET'])
@api_auth_required
def api_categories_get():
    categories = sql.get_rows('select * from api.categories_get(%s)', (None,))
    return api_return({'status': 'ok', 'result': [c for c in categories]})
