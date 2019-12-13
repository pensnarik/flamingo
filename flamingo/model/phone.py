# -*- coding: utf-8 -*-

import re

class Phone():

    @staticmethod
    def is_valid(phone):
        """
        Проверка телефона на валидность - номер телефона должен сорержать 11 цифр
        """
        return len(re.sub('\D', '', phone)) == 11

    @staticmethod
    def normalize(phone):
        """
        71234567890 -> +7 (123) 456-78-90
        """
        d = re.sub('\D', '', phone)
        return '+7 (%s) %s-%s-%s' % (d[1:4], d[4:7], d[7:9], d[9:11])

    @staticmethod
    def strip(phone):
        """
        8 (123) 456-78-90 -> 71234567890
        """
        return re.sub('\D', '', Phone.normalize(phone))
