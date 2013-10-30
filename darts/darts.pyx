# cython: profile=False, infer_types=True, boundscheck=False
# distutils: language=c++
# -*- coding: utf-8 -*-

DEF RESULT_SIZE = 100

import os.path

cdef extern from "stdio.h":
    ctypedef struct FILE
    enum: SEEK_END

    FILE *fopen(char *, char *)
    int fclose(FILE *)
    int fseek(FILE *, long int, int)
    long int ftell(FILE *)
    int fileno(FILE *)

cdef extern from "sys/mman.h":
    int PROT_READ
    int MAP_SHARED
    void *MAP_FAILED
    void *mmap(void *, size_t, int, int, int, int)
    int munmap(void *, size_t)

cdef extern from "darts.h" namespace "Darts":
    struct result_pair_type:
        int value
        size_t length
    cdef cppclass DoubleArray:
        void set_array(void *)
        void clear()
        size_t commonPrefixSearch(char *key, result_pair_type*, size_t)

cdef size_t _m_size = 0
cdef void *_m_ptr = NULL


class DartsError(Exception):
    pass


class DartsIOError(IOError):
    pass


cdef class Darts:
    """A wrapper class of Darts.

    :param str db_path: Path to the DB.
    """

    cdef DoubleArray *_da
    cdef size_t _m_size
    cdef void *_m_ptr

    def __init__(self, bytes db_path):
        self._m_size = 0
        self._m_ptr = NULL

        if not os.path.exists(db_path):
            raise DartsIOError('Darts DB not found')

        cdef FILE *fp = fopen(db_path, 'rb')

        # get the size of the dictionary
        if (fseek(fp, 0, SEEK_END) != 0):
            fclose(fp)
            raise DartsIOError('Failed to get the size of the DB')
        _m_size = ftell(fp);

        # map the dictionary file to the memory
        _m_ptr = mmap(NULL, _m_size, PROT_READ, MAP_SHARED, fileno(fp), 0)

        fclose(fp);

        if (_m_ptr == MAP_FAILED):
            raise DartsIOError('Failed to mmap')

        # tell the mmap pointer to the Darts
        self._da = new DoubleArray()
        self._da.set_array(_m_ptr)

    def __dealloc__(self):
        self._da.clear()
        munmap(self._m_ptr, self._m_size)

    cpdef bytes longest_match(self, bytes text):
        """Run common-prefix search against the text and return the longest
        result.

        :param str text: Target text.
        """
        cdef result_pair_type[RESULT_SIZE] darts_results
        cdef size_t da_size

        da_size = self._da.commonPrefixSearch(text, darts_results, RESULT_SIZE)

        cdef int i, max_len = 0

        # detect the longest length
        for i in xrange(da_size):
            if darts_results[i].length > max_len:
                max_len = darts_results[i].length

        if max_len:
            return text[:max_len]
        else:
            return None

    cpdef list common_prefix_search(self, bytes text):
        """Run common-prefix search against the text.

        :param str text: Target text.
        """
        cdef result_pair_type[RESULT_SIZE] darts_results
        cdef size_t da_size

        da_size = self._da.commonPrefixSearch(text, darts_results, RESULT_SIZE)

        ret = [text[:darts_results[i].length] for i in xrange(da_size)]

        return ret
