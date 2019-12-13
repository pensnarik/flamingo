# -*- coding: utf-8 -*-

import math
import requests
from urllib.parse import urlencode
from datetime import datetime as dt

from flamingo.module import register, PluginInterface
from flamingo.core.delivery import DeliveryInterface

__all__ = ['DeliveryFixedPrice']

class DeliveryCourier(PluginInterface, DeliveryInterface):

    def get_plugin_info(self):
        return {'version': '1.0', 'info': 'Courier delivery'}

    def calc(self, address, cart):
        if address['city'] == 'Москва' or address['region_with_type'] == 'Московская обл':
            return {'status': 'ok', 'costs': [{'title': 'Доставка курьером по Москве и области', 'cost': 0, 'code': 'courier'}]}
        else:
            return {'status': 'error'}

register(DeliveryCourier)

"""
insert into module.config (module, config)
values ('DeliveryFixedPrice', '{"costs": [{"code": "ems", "cost": 960, "title": "Посылка EMS наложенным платежом", "priority": 0}, {"code": "post", "cost": "790", "title": "Посылка 1 класса наложенным платежом", "priority": 1}]}');
"""