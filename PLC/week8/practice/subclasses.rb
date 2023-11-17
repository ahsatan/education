# SUBCLASS: every class has a superclass, Object by default
# - subclass inherits all methods from superclass
# - can override any method in subclass and add to it
# - does not inherit fields but will get method getters/setters
# syntax: class Name < Superclass
# get object's class: obj.class
# get object's superclass: obj.class.superclass (can keep chaining)
# check class: obj.is_a? ClassName => boolean (true for object's class or any superclass)
# check exact class: obj.instance_of? ClassName => boolean (true ONLY for object's class)
# IMPORTANT: overriding can make a method defined in superclass call a method in subclass!

class Point
  attr_accessor :x, :y # defines x, x=, y, y=

  def initialize(x, y)
    @x = x
    @y = y
  end

  def dist_from_origin
    Math.sqrt((@x * @x) + (@y * @y)) # direct instance variable usage
  end

  def dist_from_origin2
    Math.sqrt((x * x) + (y * y)) # getters for instance variables
  end
end

class ColorPoint < Point
  attr_accessor :color # defines color, color=

  def initialize(x, y, color = 'clear')
    super(x, y) # super calls method with SAME NAME in superclass
    @color = color
  end
end

# consider whether it's worth subclassing or just having an instance variable of that class
# advantage: could rename variables and forward to appropriate superclass method
# advantage: don't want users to treat objects of this class as superclass
# disadvantage: lose code reuse if want to maintain similar methods
# this is not a good example of when we should do that, simply a demo:
class ColorPoint2
  attr_accessor :color

  def initialize(x, y, color = 'clear')
    @pt = Point.new(x, y)
    @color = color
  end

  def x
    @pt.x
  end

  # etc. for passing y, x=, and y= to @pt
end

# Consider: should a 3D-point in space be a subclass of a 2D-point?
class ThreeDPoint < Point
  attr_accessor :z

  def initialize(x, y)
    super(x, y)
    @z = z
  end

  def dist_from_origin
    d = super
    Math.sqrt((d * d) + (@z * @z))
  end

  def dist_from_origin2
    d = super
    Math.sqrt((d * d) + (z * z))
  end
end

# Point dist_from_origin2 will correctly work because we override the methods it calls out to!
class PolarPoint < Point
  attr_reader :r, :theta
  private :r, :theta

  # by not calling super, no x and y instance variables created
  def initialize(r, theta)
    @r = r
    @theta = theta
  end

  def x
    @r * Math.cos(theta)
  end

  def y
    @r * Math.sin(theta)
  end

  def x=(a)
    b = y # avoid multiple calls to y since it's a computation not a simple getter
    @theta = Math.atan2(b, a)
    @r = Math.sqrt((a * a) + (b * b))
  end

  def y=(b)
    a = x # avoid multiple calls to x since it's a computation not a simple getter
    @theta = Math.atan2(b, a)
    @r = Math.sqrt((a * a) + (b * b))
  end

  def dist_from_origin
    r
  end
end

pp = PolarPoint.new(4, Math::PI / 4)
puts pp.x
puts pp.y
puts pp.dist_from_origin
puts pp.dist_from_origin2
