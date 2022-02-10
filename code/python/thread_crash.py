import threading

class Crash(threading.Thread):
    def run(self):
        raise RuntimeError("crash from class")

def crash():
    raise RuntimeError("crash from method")

print(">>>> start")

Crash().start()

print(">>>> mid")

threading.Thread(target=crash).start()

print(">>>> end")
