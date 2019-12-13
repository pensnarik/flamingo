# -*- coding: utf-8 -*-

import math
from urllib.parse import urlencode
from datetime import datetime as dt
import requests

from flask import render_template, abort, request

from flamingo import app, sql
from flamingo.module import register, PluginInterface
from flamingo.core.export import ExportInterface

__all__ = ['ExportOrders']

class ExportOrders(PluginInterface, ExportInterface):

    def __init__(self):
        print('Export orders init')
        super(ExportOrders, self).__init__()
        print(self.config)
        if self.config and ('token' in self.config):
            self.token = self.config['token']

    def get_plugin_info(self):
        return {'version': '1.0a', 'info': 'Orders export plugin'}

    def export(self, token):
        if token != self.config['token']:
            return abort(403)

        days = request.args.get('days', 1)
        orders = self.get_orders(days)
        date = dt.now().strftime('%Y-%m-%d %H:%M:%S')

        return render_template('module/export_orders.xml', orders=orders, date=date)

register(ExportOrders)
