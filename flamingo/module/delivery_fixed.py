# -*- coding: utf-8 -*-

import math
import requests
from urllib.parse import urlencode
from datetime import datetime as dt

from flamingo.module import register, PluginInterface
from flamingo.core.delivery import DeliveryInterface

__all__ = ['DeliveryFixedPrice']

class DeliveryFixedPrice(PluginInterface, DeliveryInterface):

    def get_plugin_info(self):
        return {'version': '1.0', 'info': 'Fixed price delivery'}

    def calc(self, address, cart):
        if self.config.get('costs', []) != []:
            return {'status': 'ok', 'costs': self.config.get('costs')}
        else:
            return {'status': 'error'}

register(DeliveryFixedPrice)

"""
insert into module.config (module, config)
values ('DeliveryFixedPrice', '{"costs": [{"code": "ems", "cost": 960, "title": "Посылка EMS наложенным платежом", "priority": 0}, {"code": "post", "cost": "790", "title": "Посылка 1 класса наложенным платежом", "priority": 1}]}');
"""