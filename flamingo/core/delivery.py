# -*- coding: utf-8 -*-

import json
from flask import request

from flamingo.core.common import DecimalEncoder
from flamingo.module import modules
from flamingo import app
from flamingo.module import get as get_module
from flamingo.model.cart import Cart
from flamingo.model.module import Module

class DeliveryInterface():

    def __init__(self):
        pass

    def calc(self, address, cart):
        raise NotImplementedError()

def return_json(data):
    resp = app.response_class(
        response=json.dumps(data, cls=DecimalEncoder),
        status=200,
        mimetype='application/json'
    )

    return resp

@app.route('/delivery/calc', methods=['POST'])
def delivery_calc():
    address = request.get_json()['address']
    cart = Cart.get(request.cookies.get('customer_id'))

    if address is None:
        return_json({'status': 'error', 'message': 'Address not defined'})

    result = []

    for module in modules:
        m = get_module(module)()
        if isinstance(m, DeliveryInterface) and Module.is_enabled(module):
            calc = m.calc(address, cart)
            if calc['status'] == 'ok':
                result += calc['costs']

    return return_json({'status': 'ok', 'result': result})

