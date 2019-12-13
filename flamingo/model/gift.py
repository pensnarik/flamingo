# -*- coding: utf-8 -*-

from flamingo import app, sql

class Gift():
    @staticmethod
    def get_gifts():
        return sql.get_rows('select * from web.gifts_get()')