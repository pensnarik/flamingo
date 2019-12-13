#!/usr/bin/env python3

import os
import json
import argparse

class App():

    # В этом массиве цвета с более длинным названием должны находиться в начале
    known_colors = ['Space Grey', 'Space Gray', 'Rose Gold', 'Jet Black',
                    'Sunrise Gold', 'Midnight Black', 'Titanium Gray', 'Coral Blue',
                    'Lilac Purple', 'Burgundy Red',
                    'Gold', 'Silver', 'Gray', 'Black']

    def __init__(self):
        parser = argparse.ArgumentParser(description='Multiple SKU')
        parser.add_argument('--filename', help='File with JSON data', type=str, required=True)
        parser.add_argument('--options', help='Options', type=str, required=True)
        parser.add_argument('--remove', help='Remove original file', action='store_true', default=False)
        self.args = parser.parse_args()

    def get_new_product_name(self, name, option):
        color_name = option.replace('-', ' ').title()
        for known_color in self.known_colors:
            if name.endswith(known_color):
                return name.replace(known_color, color_name)
        return name + ' ' + color_name

    def option_to_filename(self, option):
        return option.replace(' ', '-').lower()

    def get_new_filename(self, filename, option):
        return os.path.basename(filename).replace('.json', '-%s.json' % self.option_to_filename(option))

    def make_option(self, filename, option):
        print('Making option %s -> %s' % (filename, option,))
        contents = open(filename, 'rt').read()
        data = json.loads(contents)

        with open(self.get_new_filename(filename, option), 'wt') as f:
            data['product']['name'] = self.get_new_product_name(data['product']['name'], option)
            f.write(json.dumps(data, ensure_ascii=False, indent=4))

    def run(self):
        for option in self.args.options.split(','):
            self.make_option(self.args.filename, option.strip())
        if self.args.remove:
            os.remove(self.args.filename)


if __name__ == '__main__':
    app = App()
    app.run()
