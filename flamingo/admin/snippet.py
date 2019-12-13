# -*- coding: utf-8 -*-

from flask import render_template, redirect, request
from flask_login import login_required

from flamingo import app
from flamingo.model import Snippet, Snippets
from flamingo.core.common import return_json_ok


@app.route('/admin/snippets', methods=['GET'])
@login_required
def admin_snippets():
    return render_template('admin/snippets.html', snippets=Snippets.get())

@app.route('/admin/snippet', methods=['GET'])
@app.route('/admin/snippet/<int:id>', methods=['GET'])
@login_required
def admin_snippet_get(id=None):
    if id is None:
        snippet = None
    else:
        snippet = Snippet.get(id)

    return render_template('admin/snippet.html', snippet=snippet)

@app.route('/admin/snippet/', methods=['POST'])
@app.route('/admin/snippet/<int:id>', methods=['POST'])
@login_required
def admin_snippet_set(id=None):
    name = request.form.get('name')
    is_enabled = request.form.get('is_enabled', False)
    show_in_admin = request.form.get('show_in_admin', False)
    data = request.form.get('data')
    pos = request.form.get('pos')
    priority = request.form.get('priority')

    id_ = Snippet.set(id, name, pos, priority, is_enabled, data, show_in_admin)

    return redirect('admin/snippet/%s' % id_)

@app.route('/admin/snippet/<int:id>/delete', methods=['POST'])
@login_required
def admin_snippet_delete(id):
    result = Snippet.delete(id)

    return return_json_ok({'id': result})
