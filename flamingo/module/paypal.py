# -*- coding: utf-8 -*-

import json
import requests

from flask import request, render_template, redirect

from flamingo import app, sql
from flamingo.core.payment import PaymentInterface
from flamingo.core.common import DecimalEncoder
from flamingo.core.config import get_base_url
from flamingo.module import register, PluginInterface

__all__ = ['PayPal']

class PayPal(PluginInterface, PaymentInterface):

    api_url = 'https://api.sandbox.paypal.com'

    def __init__(self):
        super(PayPal, self).__init__()

    def get_plugin_info(self):
        return {'version': '1.0', 'info': 'Payments via PayPal'}

    def payment(self):
        order_id = request.args.get('order_id')
        order = sql.get_row('select * from web.get_order(%s, %s)', (order_id, request.args.get('token')))
        if order is None:
            return render_template('error.html', message='Order not found')

        headers = {'Content-Type': 'application/json',
                   'Authorization': 'Bearer %s' % self.config['token']}
        data = {'intent': 'sale', 'payer': {'payment_method': 'paypal'},
                'transactions': [{'amount': {'total': order['amount'], 'currency': 'USD'},
                                  'invoice_number': order_id}],
                'redirect_urls': {'return_url': '%s/payment/done' % get_base_url(),
                                  'cancel_url': '%s/payment/cancel' % get_base_url()}}
        r = requests.post('%s/%s' % (self.api_url, 'v1/payments/payment'), headers=headers,
                          data=json.dumps(data, cls=DecimalEncoder))

        if r.status_code == 201:
            external_id = r.json()['id']
            payment_id = self.create_payment('paypal', order_id, 'usd', order['amount'], external_id)
            for link in r.json()['links']:
                if link['method'] == 'REDIRECT':
                    return redirect(link['href'])
        else:
            return render_template('error.html', message=r.text)
        return 'OK'

    def payment_done(self):
        payment_id = request.args.get('paymentId')
        paypal_token = request.args.get('token')

        self.set_payment_status('paypal', payment_id, 'success')
        return render_template('payment.html', status='success')


register(PayPal)

payment_processor = PayPal()
app.add_url_rule('/payment', view_func=payment_processor.payment)
app.add_url_rule('/payment/done', view_func=payment_processor.payment_done)
