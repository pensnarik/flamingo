# -*- coding: utf-8 -*-

import os

from flask import render_template, request, redirect
from flask_login import login_required

from flamingo import app
from flamingo.model import Banner, Banners, Image
from flamingo.core.config import get_abs_image_path

@app.route('/admin/banners', methods=['GET'])
@login_required
def admin_banners():
    banners = Banners.get()
    return render_template('admin/banners.html', banners=banners)

@app.route('/admin/banner/<int:id>', methods=['GET'])
@login_required
def admin_banner(id):
    banner = Banner.get(id)
    return render_template('admin/banner.html', banner=banner)


@app.route('/admin/banner/<int:id>/upload', methods=['POST'])
@login_required
def admin_banner_upload(id):
    uploaded_file = request.files['file']

    ext = uploaded_file.filename.split('.')[-1]

    if not Image.is_valid_filename(uploaded_file.filename):
        flash('Invalid file extension')
        return redirect('/admin/banner/%s' % id)

    index = Banner.get_next_id()
    local_filename = os.path.join(get_abs_image_path(), 'banners', 'banner-%s.%s' % (index, ext,))
    uploaded_file.save(local_filename)

    return redirect('/admin/banner/%s' % id)

