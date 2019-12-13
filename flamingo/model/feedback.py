# -*- coding: utf-8 -*-

from flamingo import sql

class Feedbacks():

    @staticmethod
    def get(admin=False):
        if admin:
            return sql.get_rows('select * from admin.feedbacks_get()')
        else:
            return sql.get_rows('select * from web.get_feedback()')


class Feedback():

    @staticmethod
    def add(name, message, ip, rate):
        return sql.get_value('select web.feedback_add(%s, %s, %s, %s::smallint)',
                             (name, message, ip, rate,))

    @staticmethod
    def publish(id):
        return sql.get_value('select admin.feedback_publish(%s)', (id,))

    @staticmethod
    def reject(id):
        return sql.get_value('select admin.feedback_reject(%s)', (id,))

    @staticmethod
    def set_dt_added(id, dt_added):
        return sql.get_value('select admin.feedback_set_dt_added(%s, %s)', (id, dt_added,))
