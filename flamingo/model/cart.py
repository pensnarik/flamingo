# -*- coding: utf-8 -*-

from flamingo import app, sql

class Cart():

    @staticmethod
    def get(secret):
        result = sql.get_row('select * from web.get_cart_total(%s)', (secret,))
        return {'quantity': result['oquantity'], 'subtotal': result['oamount']}
