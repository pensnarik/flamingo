# -*- encoding: utf-8 -*-

import requests

from flamingo.core.notify import NotifyInterface
from flamingo.module import register, PluginInterface
from flamingo.core.config import get_parameter_value

class NotifyTelegram(PluginInterface, NotifyInterface):

    url = 'https://api.telegram.org/bot%(token)s/%(method)s'
    me = 30585458

    def __init__(self):
        self.read_config()

    def get_plugin_info(self):
        return {'version': '1.0', 'info': 'Telegram orders notification'}

    def send_message(self, to, text, use_markdown=False):
        data = {'chat_id': to, 'text': text[:4095]}
        if use_markdown:
            data.update({'parse_mode': 'Markdown'})
        r = requests.post(self.url % {'token': self.config['token'], 'method': 'sendMessage'}, data=data)
        print(r.text)

    def on_new_order(self, order, items):
        if self.config['is_enabled'] == False:
            return
        items = '\n'.join(['%s (%s)' % (i['name'], i['quantity'] )for i in items])
        text = '\U0001f4a5 Новый заказ %s на сайте %s!\n\n' \
               '\U0001f439 %s\n' \
               '\U0000260e %s\n' \
               '\U0001f4e7 %s\n\n' \
               'Позиции заказа:\n' \
               '%s\n' \
               'Сумма заказа (без доставки): %s руб\n' \
               'Способ оплаты: %s' % \
               (order['id'], get_parameter_value('CompanyName'), order['name'],
                order['phone'], order['email'], items, order['subtotal'],
                order['payment_method_name'])

        if self.config.get('chat_id'):
            self.send_message(self.config.get('chat_id'), text)

    def on_new_feedback(self, feedback):
        text = 'Оставлен новый отзыв на сайте %s:\n\n%s' % (feedback['site'], feedback['text'])

        self.send_message(self.me, text)

        if self.config.get('chat_id'):
            self.send_message(self.config.get('chat_id'), text)

register(NotifyTelegram)

# https://api.telegram.org/bot587947549:AAHDqHB3y-2eeiqIN9EI8m6vDDCZiBeYEdM/getUpdates

"""
insert into module.config (module, config)
values ('NotifyTelegram', '{"token": "587947549:AAHDqHB3y-2eeiqIN9EI8m6vDDCZiBeYEdM", "chat_id": "-288248839"}');
"""
