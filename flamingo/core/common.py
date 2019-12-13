import json
import decimal
import requests

from flamingo import app
from flamingo.module import get as get_module
from flamingo.core.config import get_mail_interface, get_parameter_value

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            return float(o)
        return super(DecimalEncoder, self).default(o)

def send_mail(addr_from, addr_to, subject, message):
    mailinterface = get_module(get_mail_interface())()
    mailinterface.send(addr_from, addr_to, subject, message)


def send_mail_html(addr_from, addr_to, subject, message):
    mailinterface = get_module(get_mail_interface())()
    mailinterface.send_html(addr_from, addr_to, subject, message)

def ornull(v):
    if v == '':
        return None
    return v

def return_json_ok(data={}, status=200):
    data.update({'status': 'ok'})

    resp = app.response_class(
        response=json.dumps(data, cls=DecimalEncoder),
        status=status,
        mimetype='application/json'
    )

    return resp

# For an error message with a non-200 HTTP status code, the content will not be parsed by jQuery.
def return_json_error(message, status=200):
    resp = app.response_class(
        response=json.dumps({'status': 'error', 'message': message}),
        status=status,
        mimetype='application/json'
    )

    return resp

def check_captcha(token):
    url = 'https://www.google.com/recaptcha/api/siteverify'
    data = {'secret': get_parameter_value('reCaptcha_secret'), 'response': token}
    r = requests.post(url, data=data)
    return r.json().get('success')
