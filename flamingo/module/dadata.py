# -*- coding: utf-8 -*-

import requests
from flamingo.module import register, PluginInterface

__all__ = ['Dadata']

class Dadata(PluginInterface):

    API_BASE_URL = 'https://suggestions.dadata.ru/suggestions/api/4_1'

    def __init__(self):
        super(Dadata, self).__init__()
        if self.config and ('token' in self.config):
            self.token = self.config['token']

    def get_plugin_info(self):
        return {'version': '1.0', 'info': 'Dadata integration'}

    def get_city_by_ip(self, ip):
        headers = {'Accept': 'application/json',
                   'Authorization': 'Token %s' % self.token}
        result = requests.get('%s/rs/iplocate/address?ip=%s' % (self.API_BASE_URL, ip,), headers=headers)

        print('dadata result:')
        print(result.status_code)
        data = result.json()

        if 'location' in data.keys():
            return data['location']
        else:
            return None
