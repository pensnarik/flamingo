import re
import json
from flask import render_template, g, request, make_response

from flamingo.core.common import DecimalEncoder, return_json_ok
from flamingo import app, sql
from flamingo.model.product import Product
from flamingo.model.gift import Gift

def _update_cart_item(secret, product_id, quantity=1):
    return sql.get_rows('select * from web.update_cart_item(%s, %s, %s)',
                        (secret, product_id, quantity,))

def _remove_product_from_cart(secret, product_id):
    return sql.get_row('select * from web.remove_product_from_cart(%s, %s)',
                       (secret, product_id,))

def _get_cart_totals(secret):
    query = 'select oquantity as quantity, oamount as amount from web.get_cart_total(%s)'
    return sql.get_row(query, (secret,))

def _get_new_customer():
    result = sql.get_row('select * from web.new_customer()')
    return result['osecret']

def get_current_customer():
    if 'customer_id' not in request.cookies:
        return _get_new_customer()
    else:
        return request.cookies['customer_id']

def _get_cart():
    if 'customer_id' in request.cookies:
        cart = sql.get_rows('select * from web.get_cart(%s)', (request.cookies['customer_id'],))
    else:
        cart = []
    return cart

def _set_cart_item(secret, product_id, quantity):
     return sql.get_rows('select * from web.set_cart_item(%s, %s, %s)',
                         (secret, product_id, quantity,))

"""
When an item is being added to the cart we procecc it and return
the rendered cart template which can be displayed in a popup cart window
"""

@app.route('/cart')
@app.route('/cart/')
def cart():
    gifts = Gift.get_gifts()
    if 'fast_order' in request.args:
        # This is for Ajax cart update
        for arg in request.args:
            # This is disgusting
            if 'quantity' in arg:
                m = re.search('form\[quantity\]\[(\d+)\]', arg)
                product_id = int(m.group(1))
                items = _set_cart_item(get_current_customer(), product_id, request.args.get(arg))

        return render_template('include/cart-items.html', items=_get_cart())
    else:
        return render_template('cart.html', items=_get_cart(), gifts=gifts)

@app.route('/ajax/popup-cart', methods=['GET'])
def get_popup_cart():
    return render_template('include/popup-cart.html', items=_get_cart())

@app.route('/cart/update/<id>', methods=['POST'])
def update_cart_item(id):
    quantity = int(request.args.get('quantity'))

    customer_id = get_current_customer()
    items = _update_cart_item(customer_id, id, quantity)

    new_totals = _get_cart_totals(customer_id)
    items_count = sum([i['quantity'] for i in items if i['id'] != -1])

    resp = return_json_ok({'items': items, 'total': new_totals['amount'], 'item_id': id,
                       'success': True, 'items_count': items_count})
    resp.set_cookie('customer_id', customer_id)
    return resp

@app.route('/cart/remove/<product_id>', methods=['GET', 'POST'])
def remove_product_from_cart(product_id):
    if 'customer_id' not in request.cookies:
        return app.response_class(response='error', status=501)

    new_totals = _remove_product_from_cart(request.cookies['customer_id'], product_id)

    return return_json_ok({'totals': new_totals})

@app.route('/cart/add', methods=['POST'])
def cart_add():
    if request.form.get('fast_order') == '1':
        product_id = int(request.form.get('form[goods_mod_id]'))
        product = Product.get(product_id)

        resp = app.response_class(
            response=render_template('forms/1click.html', product=product)
        )

        return resp
    else:
        product_id = int(request.form.get('form[goods_mod_id]'))
        product = Product.get(product_id)

        customer_id = get_current_customer()
        items = _update_cart_item(customer_id, product_id, 1)

        resp = app.response_class(
            response=render_template('forms/product-added-to-cart.html', product=product)
        )

        resp.set_cookie('customer_id', customer_id)

    return resp
