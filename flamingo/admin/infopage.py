# -*- coding: utf-8 -*-

from flask import request, render_template, redirect
from flask_login import login_required

from flamingo import app, sql
from flamingo.core.common import return_json_ok

@app.route('/admin/infopages')
@login_required
def admin_infopages():
    pages = sql.get_rows('select * from admin.infopages_get()')
    return render_template('admin/infopages.html', pages=pages)

@app.route('/admin/infopage', methods=['GET'])
@app.route('/admin/infopage/<int:id>', methods=['GET'])
@login_required
def admin_infopage(id=None):
    page = sql.get_row('select * from admin.infopage_get(%s)', (id,))
    return render_template('admin/infopage.html', page=page)

@app.route('/admin/infopage/', methods=['POST'])
@app.route('/admin/infopage/<int:id>', methods=['POST'])
@login_required
def admin_infopage_post(id=None):
    url = request.form.get('url')
    code = request.form.get('code')

    result = sql.get_value('select admin.infopage_set(%s, %s, %s)', (id, url, code,))

    if result is None:
        return redirect('/admin/infopages')
    else:
        return redirect('/admin/infopage/%s' % result)

@app.route('/admin/infopage/<int:id>/delete', methods=['POST'])
@login_required
def admin_infopage_delete(id):
    result = sql.get_value('select admin.infopage_del(%s)', (id,))

    return return_json_ok({'id': result})
