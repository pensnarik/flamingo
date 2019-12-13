#-*- coding: utf-8 -*-

from flask import render_template, request

from flamingo import app
from flamingo.core.common import send_mail_html, check_captcha
from flamingo.core.config import get_parameter_value

@app.route('/warranty', methods=['GET', 'POST'])
def warranty():
    if request.method == 'GET':
        return render_template('warranty.html')
    else:
        if not check_captcha(request.form.get('g-recaptcha-response')):
            return render_template('warranty.html', message='Похоже, всё-таки вы робот')

        html = render_template('mail/warranty.html',
                               name=request.form.get('name'),
                               phone=request.form.get('phone'),
                               email=request.form.get('email'),
                               order_id=request.form.get('order_id'),
                               message=request.form.get('message'))

        send_mail_html(get_parameter_value('OrderManagerTo'),
                       get_parameter_value('OrderManagerTo'),
                       'Обращение по гарантии',
                       html)
        return render_template('warranty.html', message='Ваше обращение отправлено')
