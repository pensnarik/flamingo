# -*- encoding: utf-8 -*-

import imp
import json

from flask import render_template, g, request, make_response, abort, redirect, flash

import flamingo.module

from flamingo.core.common import DecimalEncoder
from flamingo import app, sql, config
from flamingo.core.common import send_mail_html, return_json_ok, return_json_error
from flamingo.core.config import get_base_url, get_parameter_value
from flamingo.cart import _update_cart_item, get_current_customer, _get_new_customer
from flamingo.model import Product, Phone, Order
from flamingo.model.black_list import BlackList
from flamingo.core.notify import on_new_order
from flamingo.model.gift import Gift

@app.route('/send_email', methods=['GET'])
def send_email():
    id = request.args.get('id')
    Order.send_email(id)
    return 'OK'

@app.route('/order', methods=['GET'])
def order():
    gifts = Gift.get_gifts()
    return render_template('order.html', form=None, gifts=gifts)

def get_full_name(name, last_name, patronymic_name):
    return ' '.join(map(lambda x: x or '', [last_name, name, patronymic_name])).strip()

@app.route('/order', methods=['POST'])
def create_order():
    if 'customer_id' not in request.cookies or \
        BlackList.is_blacklisted(ip=request.remote_addr, phone=Phone.strip(request.form.get('phone'))):
        return abort(403)

    if not Phone.is_valid(request.form.get('phone')):
        flash('Номер телефона введён неверно, он должен содержать 11 цифр', 'error')
        return render_template('order.html', form=request.form)

    email = request.form.get('email').lower().strip()
    if request.form.get('postcode', '') == '':
        address = request.form.get('address')
    else:
        address = '%s, %s' % (request.form.get('postcode'), request.form.get('address'),)

    if request.form.get('gift_id') != '':
        _update_cart_item(request.cookies.get('customer_id'), request.form.get('gift_id'), 1)

    # TODO: Стоимость доставки рассчитывать здесь, чтобы её
    # нельзя было передать снаружи!
    order = Order.create(request.cookies.get('customer_id'),
                         request.headers.get('User-Agent'),
                         request.remote_addr,
                         email,
                         Phone.strip(request.form.get('phone')),
                         address,
                         request.form.get('city'),
                         request.form.get('name'),
                         request.form.get('delivery_code'),
                         request.form.get('delivery_name'),
                         request.form.get('delivery_cost'),
                         request.form.get('last_name'),
                         request.form.get('patronymic_name'),
                         request.form.get('payment_method_id'))

    if order['id'] == -1:
        return app.response_class(response='error', status=403)

    Order.send_email(order['id'])
    on_new_order(Order.get(order['id'], order['token']), Order.get_items(order['id'], order['token']))

    return redirect('/thankyou?order_id=%s' % order['id'])

@app.route('/thankyou')
def thankyou():
    if 'order_id' not in request.args or 'customer_id' not in request.cookies:
        return abort(403)

    order = Order.get_for_customer(request.args.get('order_id'),
                                   request.cookies.get('customer_id'))
    if order is None:
        return abort(404)

    return render_template('thankyou.html', order=order)

@app.route('/order/<id>', methods=['GET'])
def order_status(id):
    token = request.args.get('token')
    order = Order.get(id, token)

    if order is None:
        abort(404)

    return render_template('order-status.html', order=order,
                           items=Order.get_items(id, token))

@app.route('/oneclick/<int:product_id>', methods=['POST'])
def one_click(product_id):
    if BlackList.is_blacklisted(request.remote_addr, '71111112233'):
        return abort(403)

    if not Phone.is_valid(request.form.get('phone')):
        return return_json_error('Пожалуйста, введите корректный номер телефона')

    # Если product_id == 0, значит мы пришли сюда
    # из формы предзаказа и товар уже в корзине
    if product_id == 0:
        customer_id = get_current_customer()
    else:
        customer_id = _get_new_customer()
        _update_cart_item(customer_id, product_id, 1)

    resp = return_json_ok({})

    if 'customer_id' not in request.cookies:
        resp.set_cookie('customer_id', customer_id)

    order = Order.create(customer_id,
                         request.headers.get('User-Agent'),
                         request.remote_addr,
                         'oneclick@',
                         Phone.strip(request.form.get('phone')),
                         'Заказ в один клик',
                         'Заказ в один клик',
                         request.form.get('name'),
                         None,
                         'Уточняется по телефону',
                         0,
                         '',
                         '',
                         payment_method_id=None)

    info = {'status': 'ok'}

    Order.send_email(order['id'])
    on_new_order(Order.get(order['id'], order['token']), Order.get_items(order['id'], order['token']))

    return resp
