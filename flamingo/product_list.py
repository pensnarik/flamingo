# -*- coding: utf-8 -*-

from flask import request, render_template

from flamingo import app
from flamingo.model.product_list import ProductList
from flamingo.core.common import ornull

@app.route('/product-list', methods=['GET'])
def product_list():
    page_number = ornull(request.args.get('p'))

    if page_number is None or int(page_number) > 999:
        products = []
    else:
        if int(page_number) < 1:
            page_number = 1

        products = ProductList.search(manufacturer_id=ornull(request.args.get('manufacturer_id')),
                                      category_id=ornull(request.args.get('category_id')),
                                      group_id=ornull(request.args.get('group_id')),
                                      name=ornull(request.args.get('name')),
                                      order_col=ornull(request.args.get('order_col')),
                                      order_dir=ornull(request.args.get('order_dir')),
                                      page_number=page_number,
                                      products_on_page=ornull(request.args.get('items')))
    return render_template('include/product-list.html', products=products)
