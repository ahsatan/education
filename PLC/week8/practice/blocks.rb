# BLOCK: similar to closures
# - pass to methods as pseudo anonymous functions
# - take 0+ arguments
# - use lexical scope (use env where defined)
# different from closures
# - can pass 0 or 1 block to ANY message (read: method call)
#   - separate from normal method arguments
# - only action can take (in method it is passed to) is yield or yield(args)
#   - will error if no block given
#   - could have unexpected behavior if caller block uses different # of args
#   - can use block_given? but often just assume it's given
#   - second class expression: cannot return it, store it, put it in an array, etc.
# syntax for multi-line: replace { } with do end
# pipes surround arguments: { |x, y| exp }
# rarely use loops because blocks are so useful:
# - array.map (collect), array.any? (ormap), array.all? (andmap)
# - array.each, array.inject (foldl), array.filter (select)
# if need to iterate over a number range, can do (0..n).each, etc.

i = 7
[4, 6, 8].each { |x| if x < i then puts(x + 1) end } # print 5 7 on own lines

a = Array.new(5) { |x| 4 * (x + 1) }
a.map { |x| x * 2 }
a.any? { |x| x > 7 }
a.all? { |x| x > 7 }
a.inject(0) { |acc, e| acc + e } # 0 is base case
a.inject { |acc, e| acc + e } # acc inits to first element of list by default
a.filter { |x| x > 7 }
a.all? # is everything in array truthy?
a.any? # is anything in array truthy?

def silly(a)
  (yield a) + (yield 42)
end

silly(5) { |b| b * 2 }

class Foo
  attr_reader :max
  private :max

  def initialize(max)
    @max = max
  end

  def silly
    yield(4, 5) + yield(max, max)
  end

  def count(base, &block)
    if base > max
      raise 'beyond max'
    elsif yield base
      1
    else
      1 + count(base + 1, &block)
    end
  end
end
