# -*- encoding: utf-8 -*-

from flask import render_template, request, redirect
from flamingo import app, sql
from flask_login import LoginManager, UserMixin, login_required, login_user, logout_user
import hashlib

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login"

app.config.update(SECRET_KEY='UNICA_CRM_SECRET_KEY')


class User(UserMixin):
    def __init__(self, id):
        user = sql.get_row('select * from web.get_user_info(%s)',(id,), skip_auth=True)

        if user is None:
            raise Exception('No user with id = %s in the database' % id)

        self.id = id
        self.name = user['name']
        self.email = user['email']
        self.is_admin = user['is_admin']

    def __repr__(self):
        return "%s/%s, admin = %s" % (self.id, self.name, self.is_admin,)

@app.route('/login', methods=['GET'])
def login():
    return render_template('admin/login.html')

@app.route('/login', methods=['POST'])
def process_login():
    login = request.form.get('login')
    password = request.form.get('password')

    user_id = sql.get_value('select oid from web.login(%s, %s)', (login, hashlib.md5(password.encode()).hexdigest(),))
    if user_id == -1:
        return render_template('/admin/login.html', message=u'Ошибка авторизации. Проверьте имя пользователя и пароль.')
    user = User(user_id)
    login_user(user)
    return redirect('/admin')

@login_manager.user_loader
def load_user(userid):
    return User(userid)

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect('/login')
