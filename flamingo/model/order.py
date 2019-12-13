# -*- encoding: utf-8 -*-

from flask import render_template
from flamingo import app, sql
from flamingo.core.config import get_parameter_value
from flamingo.core.common import send_mail_html
from flamingo.module.dadata import Dadata

class Orders():
    @staticmethod
    def get_admin():
        query = '''
        select web.russian_date(dt_create::date) as russian_date, *
          from web.get_orders(%s, %s)
        '''
        return sql.get_rows(query, (None, None,))

    @staticmethod
    def get_by_ip(ip, exclude_id):
        query = '''select * from web.orders_by_ip_get(%s, %s)'''
        return sql.get_rows(query, (ip, exclude_id,))

class Order():

    @staticmethod
    def get(id, token=None):
        return sql.get_row('select * from web.get_order(%s, %s)', (id, token,))

    @staticmethod
    def get_admin(id):
        return sql.get_row('select * from admin.get_order(%s)', (id,))

    @staticmethod
    def create(customer_id, user_agent, ip, email, phone, address, city, name, delivery_code,
               delivery_name, delivery_cost, last_name, patronymic_name, payment_method_id):
        query = 'select oid as id, otoken as token ' \
                '  from web.create_order(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'

        return sql.get_row(query, (customer_id, email, phone, name, city, address, ip, user_agent,
                                   delivery_code, delivery_name, delivery_cost, last_name,
                                   patronymic_name, payment_method_id))

    @staticmethod
    def create_fast(product_id, email, phone, ip):
        query = 'select oid as id, otoken as token from web.create_fast_order(%s, %s, %s, %s)'
        return sql.get_row(query, (product_id, email, phone, ip,))

    @staticmethod
    def get_for_customer(id, secret):
        return sql.get_row('select * from web.get_order_for_customer(%s, %s)', (id, secret,))

    @staticmethod
    def get_items_admin(id):
        return sql.get_rows('select * from admin.get_order_items(%s)', (id,))

    @staticmethod
    def get_items(id, token=None):
        return sql.get_rows('select * from web.get_order_items(%s, %s)', (id, token,))

    @staticmethod
    def send_email(id, to_manager=True, to_customer=True):
        order = Order.get(id)
        items = Order.get_items(id)
        orders_from_this_ip = Orders.get_by_ip(order['ip'], order['id'])
        d = Dadata()
        ip_info = d.get_city_by_ip(order['ip'])

        mail = render_template('mail/order.html', order=order, items=items)
        manager_mail = render_template('mail/order-manager.html', order=order, items=items,
                                       orders_from_this_ip=orders_from_this_ip,
                                       ip_info=ip_info)

        from_addr = get_parameter_value('OrderMailFrom')

        manager_addr = get_parameter_value('OrderManagerTo')

        if order['email'] != 'onclick@':
            send_mail_html(from_addr, order['email'], 'Ваш заказ принят', mail)

        send_mail_html(from_addr, manager_addr, 'Новый заказ на сайте', manager_mail)
