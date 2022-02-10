class C():
    def __init__(self):
        self.name = type(self).__name__

class D(C):
    pass

D().name
