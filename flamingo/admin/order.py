import json

from flask import request, render_template, abort
from flask_login import login_required

from flamingo import app, sql
from flamingo.core.common import DecimalEncoder
from flamingo.model import Order, Orders


def _set_delivery_cost(id, cost):
    return sql.get_value('select admin.set_delivery_cost(%s, %s)', (id, cost,))

def _confirm_order(id):
    return sql.get_value('select admin.confirm_order(%s)', (id,))

@app.route('/admin/order/<id>')
@login_required
def admin_get_order(id):
    order = Order.get_admin(id)
    if order is None:
        return abort(404)

    return render_template('admin/order.html', order=order, items=Order.get_items_admin(id))

@app.route('/admin/orders')
@login_required
def admin_orders():
    orders = Orders.get_admin()
    dates = sql.get_rows('select * from web.get_dates_for_orders(14)')
    return render_template('admin/orders.html', orders=orders, dates=dates)

@app.route('/admin/order/set_delivery_cost', methods=['POST'])
@login_required
def admin_set_delivery_cost():
    order_id = request.form.get('order_id')
    delivery_cost = request.form.get('delivery_cost')
    result = {'status': 'ok', 'id': _set_delivery_cost(order_id, delivery_cost)}

    resp = app.response_class(
        response=json.dumps(result, cls=DecimalEncoder),
        status=200,
        mimetype='application/json'
    )

    return resp

@app.route('/admin/order/confirm', methods=['POST'])
@login_required
def admin_confirm_order():
    order_id = request.form.get('order_id')

    result = {'status': 'ok', 'id': _confirm_order(order_id)}

    resp = app.response_class(
        response=json.dumps(result, cls=DecimalEncoder),
        status=200,
        mimetype='application/json'
    )

    return resp
