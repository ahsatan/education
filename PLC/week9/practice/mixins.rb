# MIXINS (aka Traits): collection of methods
# - usually only one superclass allowed + multiple mixins per class
# - semantics: overrides methods in order mixins are added
#   - lookup method order: obj's class, mixins last to first included, then superclass chain
#   - mixins can access instance variables and methods on CURRENT SELF
#   - create: module MixinName
# - generally good style for mixins to NOT use instance variables directly as name clashes possible
# POPULAR MIXINS:
# - Comparable (define <=> to get all comparison operators)
# - Enumerable (define each to get all iterables like map, any?, filter, etc.)

module Doubler
  def double
    self + self # + not defined in Doubler! assume Classes that include will define +
  end
end

class Point
  include Doubler
  attr_accessor :x, :y

  def +(other)
    ans = Point.new
    ans.x = x + other.x
    ans.y = y + other.y
    ans
  end
end

# Extends String class
class String
  include Doubler
end

# Compare to: Multiple Inheritance
# - Multiple Superclasses: multiple of same superclass in inheritance tree can lead to problems
#   - which version of a method should be inherited if it's passed from multiple superclasses?
#   - what does super reference? e.g. need DIRECTED RESEND: Class1::super
#   - name clash: copy fields for each superclass chain? e.g. Class1::x and Class2::x or just x?

class Point2
  attr_accessor :x, :y
end

class ColorPoint < Point2
  attr_accessor :color
end

class Point3D < Point2
  attr_accessor :z
end

# Example where only want one copy of x and y superclass instance variables
# class Color3DPoint < ColorPoint, Point3D # not Ruby

class Person
  attr_accessor :pocket
end

class Artist < Person
  def draw
    # use pocket to draw with brush objects
  end
end

class Archer < Person
  def draw
    # use pocket to draw bow objects
  end
end

# Example where want pocket for both pocket superclass instance variables
# class ArtistArcher < Artist, Archer # not Ruby

# MIXIN fix for certain cases (doesn't replace Artist or Archer very well however)
module Color
  attr_accessor :color

  def darken
    @color = "dark #{color}"
  end
end

class Point3D2 < Point2
  attr_accessor :z
end

class ColorPoint2 < Point2
  include Color
end

class Color3DPoint2 < Point3D2
  include Color
end

# COMPARABLE example, <=> coloquially called "spaceship operator"
class Name
  include Comparable
  attr_accessor :first, :middle, :last

  def initialize(first, last, middle = '')
    @first = first
    @last = last
    @middle = middle
  end

  def <=>(other)
    l = last <=> other.last # uses <=> already defined on strings
    return l if l != 0

    f = first <=> other.first
    return f if f != 0

    middle <=> other.middle
  end
end

# ENUMERABLE example
class MyRange
  include Enumerable
  attr_reader :low, :high

  def initialize(low, high)
    @low = low
    @high = high
  end

  def each
    i = low
    while i <= high
      yield i # calls block on value i in range
      i += 1
    end
  end
end
