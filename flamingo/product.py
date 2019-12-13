import re
from flask import request, render_template, abort

from flamingo import app, sql
from flamingo.index import get_breadcrumbs
from flamingo.model.product import Product
from flamingo.model.category import Category
from flamingo.model.attribute_category import AttributeCategories

@app.route('/product/<id>')
def product(id):
    if id == 'favicon.ico':
        return abort(404)

    if re.match('^\d+$', id):
        product_id = int(id)
    else:
        product_id = Product.get_by_sef(id)

    if product_id is None:
        return abort(404)

    product = Product.get(product_id, force_visibility=(request.args.get('force_visibility') is not None))

    if product is None:
        return abort(404)

    Product.views_update(product_id)

    attributes = Product.get_attributes(product_id)
    category = Category.get(product['category_id'])
    for_attributes = [a['id'] for a in attributes]
    accessories = Product.get_accessories(product_id)

    return render_template('product.html', product=product,
                           breadcrumbs=Product.get_breadcrumbs(product_id, product['name']),
                           attributes=attributes,
                           attribute_categories=AttributeCategories.get(for_attributes),
                           images=Product.get_images(product_id), category=category,
                           accessories=accessories,
                           category_path=Category.path(product['category_id']))
