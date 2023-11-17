# All values are objects, even numbers and nil!
# Objects are instances of classes and contain method definitions and (private) state.
# - state persists for object's lifetime
# - instance variables (a.k.a. fields in java): @vname
#   - using an uninitialized instance variable return nil (does not error)
# - class variables: @@vname
#   - shared by all object instances, e.g. incrementing id num
# - class constants: Vname (no @, start with capital, do not mutate)
#   - visible outside class as Class::Vname
# - class methods: self.method_name(args)
#   - use: Class.method_name(args)
#   - part of class not a specific instance
#   - can only use class constants and class variables
# Methods return last expression (can explicitly use "return" too)
# newlines are important for parsing (alternative syntax available)
# self is the object this method was called on
# no need to declare variables, just assign wherever and they spring to existence
# aliasing: assigning variable references the exact original one
# - x = y => x and y point to same object
# Class initialize method will automatically get called on Class.new
# - can call with args (get passed to initialize): Class.new(arg)
# getters: attr_reader :vname1, :vname2, ...
# getters and setters: attr_accessor :vname1, :vname2, ...
# explicit setter: vname=(x)
# - allows for calling with space: obj.vname = ...
# set class methods to public (all), private (self only), or protected (class or subclass objects)
# - default public
# - use on own line in class def: will be active for methods until next visibility keyword
#   - effectively, you can declare each method's visibility since it's active until next keyword
# nil == "no data" but is an object!
# - nil.nil? => true
# - nil is the only object asides from false that also counts as false, other objects truthy
# BIG LESSON: EVERY VALUE is an object!  EVERY CALL is a method!  even operations like +
# - top-level methods are added to Object class (superclass of all other classes)
#   - every class can call these! (unless overriden)
# Reflection: provides meta information about object while program is running
# - what class it is an instance of and what methods it has
# - useful in repl: obj.methods, obj.class, ClassName.methods
#   - obj.methods - nil.methods (to find subset of methods which are more specific to obj)
#   - ClassName.class is Class!  Class.class is Class!
# DUCK TYPING: instead of requiring params to be of a class, require objects w/ the right methods
# - if it walks like a duck and quacks like a duck...we don't care if it's not actually a duck
# - could have issues with assumptions: x * 2 and x + x and 2 * x may no longer be equivalent!

class A
  def m1
    34
  end

  def m2(x, y)
    z = 7 # local variable?
    if x > y
      false
    else
      x + (y * z)
    end
  end
end

class B
  def m1
    4
  end

  def m3(x)
    (x.abs * 2) + m1
  end
end

class C
  def m1
    print 'hi '
    self # return self for easy chaining
  end

  def m2
    print 'bye '
    self
  end

  def m3
    print "\n"
    self
  end
end

class D
  AGE = 36

  attr_reader :foo

  def self.reset_bar
    @@bar = 0
  end

  def initialize(f = 0)
    @foo = f
  end

  def m2(x)
    @foo += x
    @@bar += 1
  end

  def bar
    @@bar
  end
end

class E
  def celcius_temp=(x)
    @kelvin_temp = x + 273.15
  end
end

a = A.new
a.m2(3, 4)
b = B.new
b.m3(-5)
b.m3(5)
c = C.new
c.m1.m2.m3
d1 = D.new
d2 = D.new
D.reset_bar
d1.m2(7)
d2.m2(9)
d2.foo
