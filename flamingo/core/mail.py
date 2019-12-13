# -*- coding: utf-8 -*-

class MailInterface():

    def __init__(self):
        pass

    def get_plugin_info(self):
        raise NotImplementedError()

    def send(self, addr_from, addr_to, subject, message):
        raise NotImplementedError()
