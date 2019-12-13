#!/usr/bin/env python3

import flamingo
import unittest

import logging

class FlamingoTestCase(unittest.TestCase):

    def setUp(self):
        flamingo.app.testing = True
        self.app = flamingo.app.test_client()

    def tearDown(self):
        pass

    def test_main_page(self):
        r = self.app.get('/')
        flamingo.app.logger.info(r.status_code)
        assert r.status_code == 200
        assert r.data.decode('utf-8').startswith('<!DOCTYPE html>')

if __name__ == '__main__':
    unittest.main()
