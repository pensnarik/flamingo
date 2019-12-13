# -*- coding: utf-8 -*-

import os
import re
import random
import string

from flamingo import app, sql
from flamingo.core.config import get_image_path, get_abs_image_path

cached_sizes = [200]

class Image():

    @staticmethod
    def is_valid_filename(filename):
        return filename.lower().split('.')[-1] in ['jpg', 'jpeg', 'png']

    @staticmethod
    def update_image(image):
        if not Image.is_valid_filename(image):
            return

        product_path = os.path.join(get_abs_image_path(), 'product')

        for size in cached_sizes:
            print('Updating cache for image "%s"' % image)
            cache_dir = os.path.join(product_path, '%s' % size)
            dst_name = os.path.join(cache_dir, os.path.basename(image))
            if os.path.exists(dst_name):
                continue
            if not os.path.isdir(cache_dir):
                os.makedirs(cache_dir)
            os.system('convert -geometry %sx%s "%s" "%s"' % (size, size, image, dst_name,))

    @staticmethod
    def update_cache():
        product_path = os.path.join(get_abs_image_path(), 'product')

        for image in os.listdir(product_path):
            src_name = os.path.join(product_path, image)
            Image.update_image(src_name)

    @staticmethod
    def get_cached_image_filename(image, size):
        return image.replace('/product', '/product/%s' % size)

    @staticmethod
    def get_abs_path(image):
        return os.path.join(get_abs_image_path(), re.sub('^\/static/image/', '', image))

    @staticmethod
    def remove(image):
        fullname = Image.get_abs_path(image)
        print('Removing "%s"' % fullname)
        os.remove(fullname)
        for size in cached_sizes:
            cached_image = Image.get_cached_image_filename(image, size)
            print('Removing "%s"' % Image.get_abs_path(cached_image))
            os.remove(Image.get_abs_path(cached_image))

    @staticmethod
    def is_used(url):
        return sql.get_value('select admin.is_image_url_used(%s)', (url,))

    @staticmethod
    def generate_filename(path, id, ext, priority):
        alphabet = string.ascii_lowercase + string.ascii_uppercase
        random_part =  ''.join([random.choice(alphabet) for i in range(1,5)])
        return '/%s/%s/%s-%s-%s.%s' % (get_image_path(), path, id, random_part, priority, ext)
