from flamingo import sql

class ProductList():

    @staticmethod
    def search(manufacturer_id, category_id, group_id, name, order_col, order_dir, page_number=1,
               products_on_page=24):
        query = 'select * from web.product_list_get(web.product_search(%s,%s,%s,%s,%s,%s,%s,%s))'
        return sql.get_rows(query, (manufacturer_id, category_id, group_id, name, order_col,
                                    order_dir, products_on_page, page_number))
