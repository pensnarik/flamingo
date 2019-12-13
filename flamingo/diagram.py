from flask import render_template, g, request, make_response

from flamingo import app, sql, config

def _get_diagram(vehicle_id, id):
    return sql.get_rows('select * from web.get_diagram(%s, %s)', (id, vehicle_id,))

def _get_vehicle_name(category_id):
    path = sql.get_value('select spath from web.get_breadcrumbs(%s) order by level desc limit 1', (category_id,))
    print(path)
    return ' '.join(reversed(path[1:]))

@app.route('/diagram/<vehicle_id>/<id>')
def diagram(vehicle_id, id):
    lookup_no = request.args.get('lookup_no')
    category_id = request.args.get('category_id')
    items = _get_diagram(vehicle_id, id)
    vehicle_name = _get_vehicle_name(category_id)

    return render_template('diagram.html', id=id, lookup_no=lookup_no, items=items,
                           vehicle_name=vehicle_name)
