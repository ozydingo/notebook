def group_generator(array):
    ii = 0
    jj = 0
    while ii < len(array):
        val = array[ii]
        while jj < len(array) and array[jj] == val:
            jj = jj + 1
        yield array[ii:jj]
        ii = jj

groups = group_generator([1,1,1,2,3,3,2,2])
list(groups)

#=> [[1, 1, 1], [2], [3, 3], [2, 2]]

def group_generator(array, key=None):
    def _equal(one, two):
        if key == None:
            return one == two
        else:
            return key(one) == key(two)
    ii = 0
    jj = 0
    while ii < len(array):
        val = array[ii]
        while jj < len(array) and _equal(array[jj], val):
            jj = jj + 1
        yield array[ii:jj]
        ii = jj

data = [
    {'k': 1, 'n': 0},
    {'k': 1, 'n': 1},
    {'k': 1, 'n': 2},
    {'k': 2, 'n': 3},
    {'k': 3, 'n': 4},
    {'k': 3, 'n': 5},
    {'k': 2, 'n': 6},
    {'k': 2, 'n': 7},
]
list(group_generator(data))
list(group_generator(data, key = lambda x: x['k']))
