# -*- coding: utf-8 -*-

from flask import request

from flamingo import sql

class PaymentInterface():

    def __init__(self):
        pass

    def get_plugin_info(self):
        raise NotImplementedError()

    def create_payment(self, service, order_id, currency, amount, external_id):
        return sql.get_value('select web.create_payment(%s, %s, %s, %s, %s, %s)',
                             (service, order_id, currency, amount, request.remote_addr,
                              external_id,))

    def set_payment_status(self, service, external_id, status):
        return sql.get_value('select web.set_payment_status(%s, %s, %s)',
                             (service, external_id, status))
