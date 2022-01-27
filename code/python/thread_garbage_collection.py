import threading
import time

class BigThread(threading.Thread):
        def __init__(self, n):
            threading.Thread.__init__(self)
            self.data = [1] * n
            self.stopped = False

        def run(self):
            while not self.stopped:
                time.sleep(1)

        def stop(self):
            self.stopped = True

t = BigThread(100000) # memory up

# Very unclear when memory gets freed up:

t.start()
t.stop()
t.join()

t = 0

# or

del t
