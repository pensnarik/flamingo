# -*- coding: utf-8 -*-

import os
import time
import json
import importlib

import psycopg2

from flamingo import config

modules = {}

def register(cls):
    modules[cls.__name__] = cls
    print('Module %s has been registered (%s)' % (cls.__name__, cls.get_plugin_info(cls)))

def get(name):
    return modules.get(name)

def load_modules():
    for file in os.listdir(os.path.dirname(os.path.abspath(__file__))):
        if '__' in file:
            continue
        print('Importing %s ...' % file)
        importlib.import_module('flamingo.module.%s' % file.replace('.py', ''))

class PluginInterface(object):

    config = {}

    def __init__(self):
        self.read_config()

    def read_config(self):
        retry_count = 10
        conn = None

        while retry_count > 0:
            try:
                conn = psycopg2.connect(config.get('module', 'dbconn'))
                print("Connected to database successefully")
                break
            except psycopg2.OperationalError:
                print("Could not connect to database (startup), sleeping")
                time.sleep(10)
                retry_count = retry_count - 1

        if conn is None:
            raise Exception("Could not connect to database in 10 tries")

        cursor = conn.cursor()
        cursor.execute('select module.read_config(%s)', (self.__class__.__name__,))
        r = cursor.fetchone()
        self.config = r[0] or {}
        cursor.execute('select module.is_enabled(%s)', (self.__class__.__name__,))
        r = cursor.fetchone()
        self.config['is_enabled'] = r[0]
        cursor.close()
        conn.close()
        print('%s CONFIG:' % self.__class__.__name__)
        print(json.dumps(self.config))

    def write_config(self):
        conn = psycopg2.connect(config.get('module', 'dbconn'))
        cursor = conn.cursor()
        cursor.execute('select module.write_config(%s)', (self.__class__.__name__,))
        cursor.close()
        conn.close()

    def get_plugin_info(self):
        raise NotImplementedError()
