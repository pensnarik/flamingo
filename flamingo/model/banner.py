# -*- coding: utf-8 -*-

from flamingo import sql

class Banners():

    @staticmethod
    def get():
        return sql.get_rows('select * from admin.banners_get()')

class Banner():

    @staticmethod
    def set():
        return sql.get_value('select admin.banner_set()')

    @staticmethod
    def get(id):
        return sql.get_row('select * from admin.banner_get(%s)', (id,))

    @staticmethod
    def get_next_id():
        return sql.get_value('select admin.get_next_banner_id()')
