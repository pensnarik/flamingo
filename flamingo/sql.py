import psycopg2.extras

from flask import g
from flask_login import current_user

def auth(cursor):
    if current_user.is_authenticated:
        cursor.execute('select core.auth(%s)', (current_user.id,))

def get_rows(query, args=None):
    cursor = g.conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    auth(cursor)
    cursor.execute(query, args)
    res = [r for r in cursor.fetchall()]
    cursor.close()
    return res

def get_row(query, args=None, skip_auth=False):
    cursor = g.conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    if skip_auth is False:
        auth(cursor)
    cursor.execute(query, args)
    res = cursor.fetchone()
    cursor.close()
    return res

def get_value(query, args=None):
    cursor = g.conn.cursor()
    auth(cursor)
    cursor.execute(query, args)
    res = cursor.fetchone()
    cursor.close()
    return res[0]

def execute(query, args):
    cursor = g.conn.cursor()
    auth(cursor)
    cursor.execute(query, args)
    cursor.close()
    g.conn.commit()
    return
