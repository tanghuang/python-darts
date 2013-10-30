python-darts
============

A Python binding for Darts (Double Array Trie)

.. image:: https://badge.fury.io/py/python-darts.png
    :target: http://badge.fury.io/py/python-darts

.. image:: https://travis-ci.org/studio-ousia/python-darts.png?branch=master
    :target: https://travis-ci.org/studio-ousia/python-darts

Installation
------------

.. code-block:: bash

    $ pip install Cython
    $ pip install python-darts

Usage
-----

.. code-block:: python

    >>> from darts import Darts
    >>> da = Darts('tests/mock_data.darts')
    >>> da.common_prefix_search('star wars')
    ['star', 'star wars']
    >>> da.longest_match('star wars')
    'star wars'
