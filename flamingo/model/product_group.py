# -*- coding: utf-8 -*-

from flamingo import sql

class ProductGroup():

    @staticmethod
    def get_id(mnemonic):
        return sql.get_value('select web.get_product_group_id(%s)', (mnemonic,))

    @staticmethod
    def get_name(id):
        return sql.get_value('select web.get_product_group_name(%s)', (id,))
