# -*- coding: utf-8 -*-

import math
from urllib.parse import urlencode
from datetime import datetime as dt
import requests

from flask import render_template, abort

from flamingo import app, sql
from flamingo.module import register, PluginInterface
from flamingo.core.export import ExportInterface

__all__ = ['ExportAportRu']

class ExportAportRu(PluginInterface, ExportInterface):

    def __init__(self):
        super(ExportAportRu, self).__init__()
        if self.config and ('token' in self.config):
            self.token = self.config['token']

    def get_plugin_info(self):
        return {'version': '1.0', 'info': 'aport.ru export plugin'}

    def export(self, token):
        if token != self.config['token']:
            return abort(403)

        offers = self.get_offers()
        categories = self.get_categories()
        date = dt.now().strftime('%Y-%m-%d %H:%M:%S')

        return render_template('module/export_aport_ru.xml', offers=offers,
                               categories=categories, date=date)

register(ExportAportRu)
