a = [10, 20, 30, 40, 50]
b = [17, 34]

def keyzip(primary, secondary):
    return None

a_iter = iter(a)
b_iter = iter(b)

def b_gen(a_val, b_iter):
    for b_val in b_iter:
        if b_val > a_val:
            yield b_val
    yield None

for a_val in a_iter:
    b_val = next(b_gen(a_val, b_iter))
    print({'a': a_val, 'b': b_val})
