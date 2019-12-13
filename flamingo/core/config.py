# -*- coding: utf-8 -*-

import os
from flamingo import app, sql

def get_parameter_value(parameter):
    return sql.get_value('select web.get_parameter_value(%s)', (parameter,))

def get_mail_interface():
    return get_parameter_value('MailInterface')

def get_payment_interface():
    return get_parameter_value('PaymentInterface')

def get_base_url():
    return get_parameter_value('BaseURL')

def get_image_path():
    return 'static/image'

def get_abs_image_path():
    return os.path.join(app.root_path, get_image_path())
