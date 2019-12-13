# -*- coding: utf-8 -*-

from flask import abort, Response

from flamingo import app, sql
from flamingo.module import modules
from flamingo.module import get as get_module
from flamingo.model.category import Categories

class ExportInterface():

    token = None

    def __init__(self):
        self.token = self.config['token']

    def get_offers(self):
        return sql.get_rows('select * from web.export(%s, %s)', (self.__class__.__name__, True,))

    def get_orders(self, days_limit=None):
        return sql.get_rows('select * from web.orders_export(%s)', (days_limit,))

    def get_categories(self):
        return Categories.export(self.__class__.__name__)

    def export(self):
        raise NotImplementedError()

@app.route('/export/<token>.xml')
def export(token):
    for module in modules:
        try:
            m = get_module(module)()
        except TypeError:
            print('Could not load module %s, skipping' % module)
            continue

        if isinstance(m, ExportInterface):
            if m.token == token:
                return Response(m.export(token), mimetype='text/xml')
    return abort(404)
