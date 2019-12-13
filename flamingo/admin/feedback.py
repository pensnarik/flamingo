# -*- coding: utf-8 -*-

from time import strftime
from flask import request
from flask_login import login_required

from flamingo import app
from flamingo.core.common import return_json_ok
from flamingo.model.feedback import Feedback

@app.route('/admin/feedback/<int:id>/publish', methods=['POST'])
@login_required
def admin_feedback_publish(id):
    id = Feedback.publish(id)
    return return_json_ok({'id': id})

@app.route('/admin/feedback/<int:id>/reject', methods=['POST'])
@login_required
def admin_feedback_reject(id):
    id = Feedback.reject(id)
    return return_json_ok({'id': id})

@app.route('/admin/feedback/<int:id>/set_dt_added', methods=['POST'])
@login_required
def admin_feedback_set_dt_added(id):
    data = request.get_json()
    print(data)
    result = Feedback.set_dt_added(id, data['dt_added'])

    return return_json_ok({'id': id, 'dt_added': strftime('%Y-%m-%d %H:%M:%S')})
