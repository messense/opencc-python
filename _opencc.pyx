cdef extern from "opencc/opencc.h":
    ctypedef void* opencc_t
    opencc_t opencc_open(const char*)
    int opencc_close(opencc_t)
    char* opencc_convert_utf8(opencc_t, const char*, size_t)
    void opencc_convert_utf8_free(char *)


cdef class OpenCC(object):
    cdef opencc_t _od

    def __cinit__(self, config='t2s.json'):
        if isinstance(config, unicode):
            config = config.encode('utf-8')
        self._od = opencc_open(config)

    def convert(self, text):
        if isinstance(text, unicode):
            text = (<unicode>text).encode('utf-8')
        retval = opencc_convert_utf8(self._od, text, len(text))
        value = retval.decode('utf-8')
        opencc_convert_utf8_free(retval)
        return value

    def __dealloc__(self):
        if self._od != NULL:
            opencc_close(self._od)
            self._od = NULL


def convert(text, config='t2s.json'):
    cc = OpenCC(config)
    return cc.convert(text)
