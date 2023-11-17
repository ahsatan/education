# HASH: key-value pairs w/o natural ordering
# - example: pass named config values all in one variable
# access non-existent keys returns nil
# hash.keys => list of keys
# hash.values => list of values

h = {} # can also use Hash.new
h['a'] = 'Found A'
h[false] = 'Found false'
puts h

g = { 'SML' => 1, 'Racket' => 2, 'Ruby' => 3 }
g.each { |k, v| puts "#{k}: #{v}" }
puts g

k = { SML: 1, Racket: 2, Ruby: 3 } # can use symbols instead of strings for keys
puts k
