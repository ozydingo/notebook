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
