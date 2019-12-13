# -*- coding: utf-8 -*-

from flamingo import sql

class Manufacturers():

    @staticmethod
    def get():
        return sql.get_rows('select * from admin.manufacturers_get()')
