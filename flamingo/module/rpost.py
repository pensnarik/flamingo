# -*- coding: utf-8 -*-

import math
import requests
from urllib.parse import urlencode
from datetime import datetime as dt

from flamingo.module import register, PluginInterface
from flamingo.core.delivery import DeliveryInterface

__all__ = ['RussianPost']

class RussianPost(PluginInterface, DeliveryInterface):

    url = 'http://tariff.russianpost.ru/tariff/v1/calculate?json&'

    def get_plugin_info(self):
        return {'version': '1.1', 'info': 'Russian post delivery cost calculation'}

    def calc(self, address, cart):
        costs = []
        params = {'date': dt.now().strftime('%Y%m%d'),
                  'from': self.config['sender_post_code'],
                  'to': address.get('postal_code'),
                  'pack': self.config['pack'],
                  'weight': int(cart['quantity'] * int(self.config.get('default_weight', 500))),
                  'sumoc': int(cart['subtotal']) * 100}

        # Другие возможные значения:
        # '28040': 'Посылка EMS наложенным платежом'
        services = {'47040': 'Посылка 1 класса наложенным платежом'}

        priority = 0

        for object_code in services.keys():
            params.update({'object': object_code})
            result = requests.get(self.url + urlencode(params))
            result_json = result.json()

            if 'errors' in result_json:
                continue
            costs.append({'cost': math.ceil(result_json['paynds'] / 100.0) + \
                                  self.config.get("margin", 0),
                          'title': services[object_code],
                          'code': 'russian.post.%s' % object_code,
                          'priority': priority})
            priority += 1

        if len(costs) == 0:
            return {'status': 'error', 'costs': []}
        else:
            return {'status': 'ok', 'costs': costs}

register(RussianPost)
