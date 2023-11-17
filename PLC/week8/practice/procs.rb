# PROC: actual closure version of block
# - first class expressions
#   - result of a computation that can be stored, returned, passed around, etc.
# creation of Proc objects (can then .call it):
# - lambda { |args| body }
# - ->(args) { body }
# - Proc.new { |args| body }
# - proc { |args| body }
# - def make_proc(&block)
#     block
#   end
#   p = make_proc { |args| body }
# - regular proc and lambda version differences: https://docs.ruby-lang.org/en/3.0/Proc.html
# need for callbacks
# less convenient for basic cases like calling a standard map

a = [3, 5, 7, 9]
b = a.map { |x| ->(y) { x >= y } } # map a to list of closures
puts b
puts b[2].call(6)
puts b[2].call(8)
puts(b.count { |x| x.call(5) })
