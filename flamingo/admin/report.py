from flask import render_template
from flask_login import login_required

from flamingo import app
from flamingo.model import ReportPriceHistory, ProductViewStat

@app.route('/admin/price_history')
@login_required
def report_price_history():
    return render_template('admin/price-history.html', rows=ReportPriceHistory.get())

@app.route('/admin/stat')
@app.route('/admin/stat/<string:day>')
@login_required
def admin_stat(day=None):
    ProductViewStat.get(day)

    return 'OK'
