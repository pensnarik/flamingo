# -*- coding: utf-8 -*-

from flamingo import app, sql

class Products():
    @staticmethod
    def get(category_id):
        return sql.get_rows('select * from web.product_list_get(web.get_products(%s))', (category_id,))

    @staticmethod
    def get_admin(category_id, name, order_by, order_dir, page):
        return sql.get_rows('select * from admin.products_get(%s, %s, %s, %s, %s)',
                            (category_id, name, order_by, order_dir, page,))

    @staticmethod
    def get_admin_products_count(category_id, name):
        return sql.get_value('select id from admin.products_get(%s, %s, %s, %s, %s)',
                             (category_id, name, 'p.sku', 'asc', 0,))

    @staticmethod
    def get_popular():
        return sql.get_rows('select * from web.product_list_get(web.get_popular_products())')

    @staticmethod
    def search(name):
        return sql.get_rows('select * from web.search(%s)', (name,))

    @staticmethod
    def list_get(filters, include_subcategories=True):
        args = ()
        for arg in ['manufacturer_id', 'category_id', 'group_id',
                    'search', 'order_col', 'order_dir', 'limit', 'page', 'filters']:
            args += (filters.get(arg),)
        args += (include_subcategories,)
        return sql.get_rows('select * from web.product_list_get(web.product_search(%s, %s, %s, %s, '
                            '%s, %s, %s, %s, %s, %s))', args)

    @staticmethod
    def list_get_count(filters, include_subcategories=True):
        args = ()
        for arg in ['manufacturer_id', 'category_id', 'group_id',
                    'search', 'order_col', 'order_dir', 'filters']:
            args += (filters.get(arg),)
        args += (include_subcategories,)
        return sql.get_value('select array_length(web.product_search(%s, %s, %s, %s, '
                             '%s, %s, 10000, 1, %s, %s), 1)', args) or 0

class Product():

    @staticmethod
    def get(id, force_visibility=False):
        return sql.get_row('select * from web.product_list_get(%s, %s)', ([id], force_visibility,))

    @staticmethod
    def admin_get(id):
        return sql.get_row('select * from admin.product_get(%s)', (id,))

    @staticmethod
    def get_images(id, size=-1):
        return sql.get_rows('select * from web.get_product_images(%s, %s)', (id, size,))

    @staticmethod
    def get_id(sku):
        return sql.get_value('select api.get_product_id(%s)', (sku,))

    @staticmethod
    def get_new_image_name(id):
        new_index = sql.get_value('select admin.get_max_image_index(%s)', (id,)) + 1
        return ('%s_%s' % (id, new_index), new_index)

    @staticmethod
    def add_image(id, index, url):
        return sql.get_value('select admin.product_add_image(%s, %s, %s)', (id, index, url,))


    @staticmethod
    def delete_image(id, image_id):
        return sql.get_value('select admin.product_delete_image(%s, %s)', (id, image_id,))

    @staticmethod
    def get_category(id):
        return sql.get_value('select web.get_product_main_category(%s)', (id,))

    @staticmethod
    def get_breadcrumbs(id, name):
        """
        name тут для того, чтобы добавить его к концу списка - это будет неактивная
        ссылка в breadcrumbs
        """
        category_id = Product.get_category(id)

        if category_id is None:
            return None

        query = "select *, web.get_category_url(id) as url from web.get_breadcrumbs(%s) order by level desc"

        breadcrumbs = sql.get_rows(query, (category_id,))

        return breadcrumbs + [{'name': name}]

    @staticmethod
    def get_attributes(id):
        return sql.get_rows('select * from web.get_attributes(%s)', (id,))

    @staticmethod
    def update(id, fields):
        return sql.get_value('select admin.product_set(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                             (id, fields['name'], fields['description'],
                              fields['price'], fields['available'], fields['is_visible'],
                              fields['category_id'], fields['manufacturer_id'], fields['sku'],
                              fields['previous_price'], fields['sef_name'], fields['gtin']))
    @staticmethod
    def delete(id):
        return sql.get_value('select admin.product_del(%s)', (id,))

    @staticmethod
    def views_update(id):
        return sql.get_value('select stat.product_stat_update(%s, %s, %s, %s)', (id, 1, 0, 0,))

    @staticmethod
    def get_by_sef(sef):
        return sql.get_value('select web.product_by_sef_get(%s)', (sef,))

    @staticmethod
    def get_accessories(id):
        return sql.get_rows('select * from web.product_list_get(web.product_accessories_get(%s))', (id,))

    @staticmethod
    def diagrams_set(id, diagrams):
        return sql.get_value('select * from api.diagrams_set(%s, %s)', (id, diagrams,))

    @staticmethod
    def product_group_set(id, mnemonic, name):
        return sql.get_value('select api.product_group_set(%s, %s, %s)', (id, mnemonic, name,))
