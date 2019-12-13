# -*- coding: utf-8 -*-

from flamingo.module import modules
from flamingo.module import get as get_module
from flamingo import sql

class Module():
    @staticmethod
    def is_enabled(module):
        return sql.get_value('select web.is_module_enabled(%s)', (module,))

    @staticmethod
    def module_category_set(module, category_id, is_exported):
        return sql.get_value('select admin.module_category_set(%s, %s, %s)',
                             (module, category_id, is_exported,))

    @staticmethod
    def get_export_modules():
        result = []

        for module in modules:
            if module.startswith('Export'):
                result.append(module)

        result.sort()
        return result

    @staticmethod
    def is_exported(module, category_id):
        return sql.get_value('select admin.module_category_get(%s, %s)', (module, category_id,))
