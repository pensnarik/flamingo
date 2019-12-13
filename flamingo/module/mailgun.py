# -*- coding: utf-8 -*-

import requests

from flamingo.core.mail import MailInterface
from flamingo.module import register, PluginInterface

__all__ = ['MainGun']

class MailGun(PluginInterface, MailInterface):

    def get_plugin_info(self):
        return {'version': '1.0', 'info': 'Send mail messages via mailgun.org'}

    def send(self, addr_from, addr_to, subject, message):
        requests.post('%s/messages' % self.config['url'],
            auth=("api", self.config['key']),
            data={"from": addr_from,
                  "to": [addr_to],
                  "subject": subject,
                  "text": message})

    def send_html(self, addr_from, addr_to, subject, message):
        response = requests.post('%s/messages' % self.config['url'],
                                 auth=("api", self.config['key']),
                                 data={"from": addr_from,
                                       "to": [addr_to],
                                       "subject": subject,
                                       "html": message})
        if response.status_code != 200:
            print("MailGun: Cannot send e-mail, got %s HTTP response" % response.status_code)
            print(response.text)
            return False

        return True

register(MailGun)
