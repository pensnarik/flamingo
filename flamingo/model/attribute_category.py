# -*- coding: utf-8 -*-

from flamingo import sql

class AttributeCategories():

    @staticmethod
    def get(for_attributes=None):
        return sql.get_rows('select * from web.attribute_categories_get(%s)', (for_attributes,))
