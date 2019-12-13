# -*- coding: utf-8 -*-

from flamingo import sql

class BlackList():

    @staticmethod
    def is_blacklisted(ip, phone):
        if ip == '127.0.0.1':
            return False
        if phone == '71111112233':
            return False
        return sql.get_value('select web.is_ip_blacklisted(%s)', (ip,))
