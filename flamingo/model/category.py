# -*- coding: utf-8 -*-

import psycopg2

from flamingo import sql
from flamingo.model.module import Module

class Categories():

    @staticmethod
    def get(parent_id, admin=False):
        if admin:
            query = 'select * from admin.categories_get(%(parent_id)s)'
        else:
            query = 'select * from web.get_categories(%(parent_id)s)'
        return sql.get_rows(query, {'parent_id': parent_id})

    @staticmethod
    def export(module):
        return sql.get_rows('select * from web.categories_for_export_get(%s)', (module,))

class Category():

    @staticmethod
    def get(id):
        return sql.get_row('select * from web.get_category(%s)', (id,))

    @staticmethod
    def set(id, name, parent_id, is_exported, sort_order):
        return sql.get_value('select admin.category_set(%s, %s, %s, %s, %s)',
                             (id, name, parent_id, is_exported, sort_order,))

    @staticmethod
    def delete(id):
        try:
            return sql.get_value('select admin.category_del(%s)', (id,))
        except psycopg2.IntegrityError:
            return -1

    @staticmethod
    def path(id):
        return sql.get_value('select web.category_path(%s)', (id,))

    @staticmethod
    def module_export_settings(category_id):
        result = []

        for module in Module.get_export_modules():
            result.append({'module': module, 'is_exported': Module.is_exported(module, category_id)})

        return result

    @staticmethod
    def has_childs(category_id):
        return sql.get_value('select web.category_has_childs(%s)', (category_id,))
