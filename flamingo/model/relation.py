# -*- coding: utf-8 -*

from flamingo import sql

class Relations():
    @staticmethod
    def get(product_id, relation):
        return sql.get_rows('select * from web.product_relations_get(%s, %s)',
                            (product_id, relation,))

class Relation():

    @staticmethod
    def set(parent_id, child_id, relation):
        return sql.get_value('select admin.product_relation_set(%s, %s, %s)',
                             (parent_id, child_id, relation,))

    @staticmethod
    def delete(id):
        return sql.get_value('select admin.product_relation_del(%s)', (id,))
