from flask import render_template, request, abort

from flamingo import app

@app.route('/sale')
def sale():
    actions = {'14': 'action_14.html', '15': 'action_15.html', '16': 'action_16.html'}
    action = request.args.get('action')

    if action not in actions.keys():
        return abort(404)

    return render_template('specific/%s' % actions[action])
