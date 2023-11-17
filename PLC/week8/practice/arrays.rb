# create: a = [] or a = [3, 5, 7]
# - use block to define elements of array of size num: Array.new(num) { exp }
# get: a[i]
# - a[>len] => nil
# - a[-#] => count from end of array, e.g. a[-1] is 7
# - out of bounds => nil, e.g. a[-4]
# set: a[i] = x
# - can assign (positive) out of bounds: fills in gap elements w/ nil
# - mixed types are ok
# - can out of bounds on negative: a[-4] = 5
# a1 + a2 => concats arrays (returns new array, does not mutate a1)
# a1 | a2 => concats and removes duplicate elements (keeps first encountered)
# - uses eql? to compare
# can easily serve as a tuple
# can easily use as stack: a.push, a.pop (add and remove from end)
# can easily use as queue: a.push, a.shift (remove from front)
# - cut the queue: a.unshift (add to front)
# alias: a2 = a1 => both point to same! mutations affect both
# - a2 = a1 + [] => point to different arrays, + produces new array with same elements
#   - sub-elements can ALSO be aliased though!
#     - a = [[1, 2], [3, 4]]
#       b = a + []
#       a[0][0] = 6 => a and b both now have [[6, 2], [3, 4]]
#     - if adding/removing element or replacing entire element, will only affect one
# slice: a[1, 5] => starting from index 1, return sub-array 5 elements long
# - can assign (any number of elements) to replace slice: a[1, 5] = [1, 1]
# iterate list: [1, 3, 4, 12].each { |i| puts (i * i) }
a = []
b = [3, 5, 7]
Array.new(5) # [nil, nil, nil, nil, nil]
Array.new(3) { 0 } # [0, 0, 0]
Array.new(7) { |i| -i } # [0, -1, -2, -3, -4, -5, -6]
a[3] # nil
b[-1] # 7
b[-4] # nil
a[3] = [1, 2] # [nil, nil, nil, [1, 2]]
b[-4] = 5 # error
c = a + b # [nil, nil, nil, [1, 2], 3, 5, 7]
d = a | b # [nil, [1, 2], 3, 5, 7]
e = c + []
d[1][0] = 6 # [nil, [6, 2], 3, 5, 7]
e # [nil, nil, nil, [6, 2], 3, 5, 7]
a[2, 2] # [nil, [6, 2]]
a[0, 2] = 3 # [3, nil, [6, 2]]
a[1, 1] = [2, 5, 4] # [3, 2, 5, 4, [6, 2]]
a.each { |i| puts(i * i) } # print 9 4 25 16 (on own lines) then error on array * array
