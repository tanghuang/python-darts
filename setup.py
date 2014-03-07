# -*- coding: utf-8 -*-

from distutils.core import setup
from Cython.Build import cythonize

setup(
    name='python-darts',
    version='0.0.2',
    description='A Python binding for Darts (Double Array Trie)',
    long_description=open('README.rst').read(),
    author='Studio Ousia',
    author_email='admin@ousia.jp',
    url='http://github.com/studio-ousia/python-darts',
    ext_modules=cythonize('darts.pyx', language='c++'),
    license=open('LICENSE').read(),
    keywords=['darts', 'trie'],
    classifiers=(
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'Natural Language :: English',
        'License :: OSI Approved :: Apache Software License',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
    )
)
