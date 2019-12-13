# -*- coding: utf-8 -*-

from flask import render_template, request
from flask_login import login_required

from flamingo import app, sql
from flamingo.model.category import Category, Categories
from flamingo.model.module import Module
from flamingo.core.common import ornull, return_json_ok, return_json_error

@app.route('/admin/categories')
@login_required
def admin_categories():
    return render_template('admin/categories.html', categories=Categories.get(None, admin=True))

@app.route('/admin/category/set', methods=['POST'])
@login_required
def admin_category_set():

    data = request.get_json()
    id = ornull(data['id'])
    name = ornull(data['name'])
    parent_id = ornull(data['parent_id'])
    is_exported = data['is_exported']
    sort_order = data['sort_order']

    result = Category.set(id, name, parent_id, is_exported, sort_order)

    if result is not None:
        return return_json_ok({'id': result})
    else:
        return return_json_error('Could not update category')

@app.route('/admin/category/<int:id>/del', methods=['POST'])
@login_required
def admin_category_del(id):
    result = Category.delete(id)

    if result > 0:
        return return_json_ok({'id': result})
    else:
        return return_json_error('Could not delete category')

@app.route('/admin/category/<int:category_id>')
def admin_module_export_settins(category_id):
    category = Category.get(category_id)
    export_settings = Category.module_export_settings(category_id)
    return render_template('admin/category.html', category=category,
                           export_settings=export_settings)

@app.route('/admin/category/<int:category_id>/toggle-export', methods=['POST'])
def admin_category_toggle_export(category_id):

    settings = request.get_json()
    result = Module.module_category_set(settings['module'], category_id, settings['is_exported'])

    return return_json_ok({'id': result, 'module': settings['module']})
