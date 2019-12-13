import re
import json
from flask import request

from flamingo import app
from flamingo.model.order import Order
from flamingo.model.product import Product

# Integration with LeadGenic

@app.route('/api/leadgenic_notify', methods=['POST'])
def leadgenic_notify():
    data = request.get_json()
    m = re.match('^.*/product/(.*)$', data['pageUrl'])
    product = m.group(1)

    if re.match('^\d+$', product):
        product_id = product
    else:
        product_id = Product.get_by_sef(product)

    order = Order.create_fast(product_id, data.get('email', 'oneclick@leadgen'),
                              data.get('phone'), request.remote_addr)

    Order.send_email(order['id'])

    return json.dumps({'success':True}), 200, {'ContentType':'application/json'}
