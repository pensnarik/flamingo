# -*- coding: utf-8 -*-

from flask import render_template, request, flash, redirect

from flamingo import app, sql
from flamingo.model.feedback import Feedback, Feedbacks
from flamingo.core.common import return_json_ok, check_captcha
from flamingo.core.config import get_parameter_value
from flamingo.core.notify import on_new_feedback

@app.route('/feedback', methods=['GET'])
def feedback():
    feedbacks = Feedbacks.get(admin=True)
    return render_template('feedback.html', feedbacks=feedbacks)

@app.route('/feedback', methods=['POST'])
def feedback_add():
    if check_captcha(request.form.get('g-recaptcha-response')):
        id = Feedback.add(request.form.get('name'), request.form.get('message'), request.remote_addr, 5)
        if False:
            on_new_feedback({'site': get_parameter_value('CompanyName'),
                             'text': request.form.get('message')[:1000]})
        flash('Спасибо! Ваш отзыв будет опубликован сразу после проверки модератором.')
    else:
        flash('И всё-таки, вы робот', 'error')
    return redirect('/feedback')
