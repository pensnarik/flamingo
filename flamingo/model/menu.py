# -*- coding: utf-8 -*-

from flamingo import sql

class Menu():

    @staticmethod
    def get_json():
        return sql.get_value('select web.get_menu_json()')
