from BrickPi import *
from functools import wraps
import errno
import os
import signal

class TimeoutError(Exception):
    pass

def timeout(seconds=1, error_message=os.strerror(errno.ETIME)):
    def decorator(func):
        def _handle_timeout(signum, frame):
            raise TimeoutError(error_message)

        def wrapper(*args, **kwargs):
            signal.signal(signal.SIGALRM, _handle_timeout)
            signal.alarm(seconds)
            try:
                result = func(*args, **kwargs)
            finally:
                signal.alarm(0)
            return result

        return wraps(func)(wrapper)

    return decorator



def BrickPiWait(duration):
	ot = time.time()
	while (time.time() - ot < duration):
		BrickPiUpdateValues()
		time.sleep(.1)


def BrickPiGetSensor(port):
	try:
		code = TimeoutUpdate()
		if code == 0:
			return BrickPi.Sensor[port]
		else:
			return -1
	except TimeoutError:
		return -1
 
@timeout()
def TimeoutUpdate():
	return BrickPiUpdateValues()
