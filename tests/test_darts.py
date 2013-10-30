# -*- coding: utf-8 -*-

import sys
import os
from nose.tools import *

err = sys.stderr

from darts import Darts


class TestDarts(object):
    def setUp(self):
        data_path = os.path.join(os.path.dirname(__file__), 'mock_data.darts')
        self._ins = Darts(data_path)

    def test_common_prefix_search(self):
        eq_(['star'], self._ins.common_prefix_search('star'))
        eq_(['star', 'star wars'], self._ins.common_prefix_search('star wars'))

    def test_longest_match(self):
        eq_('star', self._ins.longest_match('star'))
        eq_('star wars', self._ins.longest_match('star wars'))
