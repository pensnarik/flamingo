# -*- coding: utf-8 -*-

import math
from urllib.parse import urlencode
from datetime import datetime as dt
import requests

from flask import render_template, abort

from flamingo import app, sql
from flamingo.module import register, PluginInterface
from flamingo.core.export import ExportInterface
from flamingo.model.category import Categories

__all__ = ['ExportAvitoRu']

class ExportAvitoRu(PluginInterface, ExportInterface):

    def __init__(self):
        super(ExportAvitoRu, self).__init__()
        if self.config and ('token' in self.config):
            self.token = self.config['token']

    def get_plugin_info(self):
        return {'version': '1.0', 'info': 'aport.ru export plugin'}

    def cagetory_mapping(self, category):
        if category.startswith('Samsung'):
            return 'Samsung'
        if category.startswith('Nokia'):
            return 'Nokia'
        # TODO: сделать настроечную таблицу для этого,
        # что-то вроде дополнительных атрибутов категорий
        mapping = {'USB адаптеры': 'Кабели и адаптеры',
                   'USB кабеля': 'Кабели и адаптеры',
                   'Стекла для iPhone': 'Чехлы и плёнки',
                   'Стекла для Samsung': 'Чехлы и плёнки',
                   'Стекла и чехлы для iPhone X': 'Чехлы и плёнки',
                   'Чехлы для iPhone': 'Чехлы и плёнки',
                   'Чехлы для Samsung': 'Чехлы и плёнки',
                   'Аккумуляторные батареи': 'Аккумуляторы',
                   'Samsung': 'Samsung',
                   'Motorola': 'Motorola',
                   'Nokia': 'Nokia',
                   'Nokia Lumia': 'Nokia',
                   'Nokia Classic': 'Nokia',
                   'Sony Xperia': 'Sony',
                   'Sony Ericsson': 'Sony',
                   'iPhone 6': 'iPhone',
                   'iPhone 6S': 'iPhone',
                   'iPhone 5S': 'iPhone',
        }
        return mapping.get(category)

    def export(self, token):
        if token != self.config['token']:
            return abort(403)

        offers_ = self.get_offers()
        offers = []

        for offer in offers_:
            print(offer)
            avito_category = self.cagetory_mapping(offer['category_name'])
            if avito_category is not None:
                offer.update({'avito_category': avito_category})
                offers.append(offer)

        return render_template('module/export_avito_ru.xml', offers=offers,
                               contact_phone=self.config.get('contact_phone'))

register(ExportAvitoRu)
