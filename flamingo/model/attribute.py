from flamingo import sql

class AttributeValue():

    @staticmethod
    def set(sku, attribute_category, attribute_name, value, create_if_not_exists=False):
        return sql.get_value('select api.attribute_value_set(%s, %s, %s, %s, %s)',
                             (sku, attribute_category, attribute_name, value, create_if_not_exists))
