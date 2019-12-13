# -*- coding: utf-8 -*-

from flamingo import sql

class Snippets():

    @staticmethod
    def get():
        return sql.get_rows('select * from admin.snippets_get()')

class Snippet():

    @staticmethod
    def get(id):
        return sql.get_row('select * from admin.snippet_get(%s)', (id,))

    @staticmethod
    def set(id, name, pos, priority, is_enabled, data, show_in_admin):
        return sql.get_value('select admin.snippet_set(%s, %s, %s, %s, %s, %s, %s)',
                             (id, name, pos, priority, is_enabled, data, show_in_admin,))

    @staticmethod
    def delete(id):
        return sql.get_value('select admin.snippet_del(%s)', (id,))
