from flask import render_template
from flamingo import app
from flamingo.model import Order

@app.route('/blank/107/<int:order_id>')
def blank_107(order_id):
    items = Order.get_items_admin(order_id)
    return render_template('module/rp107.html', items=items)

