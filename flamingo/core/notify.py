# coding: utf-8 -*-

from flamingo.module import modules, get as get_module
from flamingo.model.module import Module

class NotifyInterface(object):

    def on_new_order(self, order, items):
        raise NotImplementedError

def on_new_order(order, items):
    for module in modules:
        m = get_module(module)()
        if isinstance(m, NotifyInterface) and Module.is_enabled(module):
            m.on_new_order(order, items)

def on_new_feedback(feedback):
    for module in modules:
        m = get_module(module)()
        if isinstance(m, NotifyInterface) and Module.is_enabled(module):
            print(m)
            m.on_new_feedback(feedback)
