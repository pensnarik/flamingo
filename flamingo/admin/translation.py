# -*- encoding: utf-8 -*-

import json

from flask import render_template, request
from flask_login import login_required

from flamingo import app, sql

def _get_translations(original):
    return sql.get_rows('select * from i18n.get_translations(%s)', (original,))

@app.route('/admin/translation')
@login_required
def admin_translation():
    original = request.args.get('search')

    if original is not None:
        translations = _get_translations(original)
    else:
        translations = []

    return render_template('admin/translation.html', translations=translations, search=original)

@app.route('/admin/add_translation', methods=['POST'])
@login_required
def admin_add_translation():
    id = request.form.get('id')
    original = request.form.get('original')
    translation = request.form.get('translation')

    print('original/translation: %s/%s' % (original, translation))
    result = sql.get_value('select i18n.add_translation(%s, %s)', (original, translation,))

    response = app.response_class(
        response=json.dumps({'id': id, 'translation': translation}, ensure_ascii=False),
        status=200,
        mimetype='application/json'
    )
    return response

@app.route('/admin/update_translations', methods=['POST'])
@login_required
def admin_update_translations():

    count = sql.get_value('select i18n.update_translations()')

    response = app.response_class(
        response=json.dumps({'count': count}),
        status=200,
        mimetype='application/json'
    )

    return response
