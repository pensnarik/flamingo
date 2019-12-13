# -*- coding: utf-8 -*-

from datetime import datetime as dt

from flask import render_template

from flamingo import sql
from flamingo.core.config import get_parameter_value
from flamingo.core.common import send_mail_html

class ReportPriceHistory:

    @staticmethod
    def get():
        return sql.get_rows('select * from admin.price_history_get()')

class ProductViewStat:

    @staticmethod
    def get(day=None):
        if day is None:
            day = dt.now().strftime('%Y-%m-%d')

        stat = sql.get_rows('select * from web.export_stat(%s)', (day,))

        manager_mail = render_template('mail/product_stat.html', stat=stat)
        manager_addr = 'mail@example.com'

        send_mail_html(get_parameter_value('OrderMailFrom'), manager_addr,
                       'Статистика по просмотрам за %s' % day, manager_mail)
