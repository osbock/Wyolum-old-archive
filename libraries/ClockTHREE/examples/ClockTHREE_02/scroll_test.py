from C3_interface import *
import sys

if __name__ == '__main__':
    msg = ' '.join(sys.argv[1:])
    J = ord('J')
    try:
        delete_did(J)
    except:
        pass
    print msg
    set_data(J, (msg + '  '))
    scroll_data(J)
