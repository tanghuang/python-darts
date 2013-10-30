# -*- coding: utf-8 -*-

import sys
from setuptools import setup, find_packages
from Cython.Build import cythonize

if 'setuptools.extension' in sys.modules:
    m = sys.modules['setuptools.extension']
    m.Extension.__dict__ = m._Extension.__dict__

setup(
    name='python-darts',
    version='0.0.1',
    description='A Python binding for Darts (Double Array Trie)',
    long_description=open('README.rst').read(),
    author='Studio Ousia',
    author_email='admin@ousia.jp',
    url='http://github.com/studio-ousia/pydarts',
    packages=find_packages(),
    ext_modules=cythonize('darts/*.pyx'),
    license=open('LICENSE').read(),
    include_package_data=True,
    keywords=['darts', 'trie'],
    classifiers=(
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'Natural Language :: English',
        'License :: OSI Approved :: Apache Software License',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
    ),
    setup_requires=[
        'setuptools_cython',
    ],
    tests_require=[
        'nose',
    ],
    test_suite = 'nose.collector'
)
