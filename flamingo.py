#!/usr/bin/env python3

from flamingo import app

if __name__ == "__main__":
    app.debug = True
    app.run(host='0.0.0.0')
