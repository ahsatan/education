# DOUBLE DISPATCH: first method call further calls out to another method with more information
# in this case, we need the type of at least one value
# - first method call uses dynamic dispatch to go to first value's class method
#   - first class can call a more appropriate method since it knows its own type
# - then that calls methed on second value using dynamic dispatch
#   - now have info about both value's classes!
# MULTIPLE DISPATCH (aka MULTIMETHODS): not available in Ruby
# - define method-with-same-names' param type(s) so first (dynamic) dispatch routes correctly
#   - multimethods allow dynamic dispatch to use BOTH receiver and argument types to route
#     - Ruby does not allow labeling params with types nor multiple methods with same name in same class
#   - normal dynamic dispatch uses only receiver type which is why we needed double dispatch
# - challenge: subclassing can lead to "no clear winner" situation
# - not same as static overloading in Java/C#/C++

class Exp
  # Common functionality...
end

class Value < Exp
  # Common functionality...
end

class Int < Value
  attr_reader :i

  def initialize(i)
    @i = i
  end

  def eval
    self
  end

  def to_string
    @i.to_s
  end

  def contains_zero
    i.zero?
  end

  def no_neg_constants
    i.negative? ? Negate.new(Int.new(-i)) : self
  end

  # first dispatch: now know self is Int
  def add_values(v)
    v.addInt self
  end

  # second dispatch: v is Int
  def add_int(v)
    Int.new(v.i + i)
  end

  # second dispatch: v is MyString
  # 'add' in opposite order due to self flipping Values with double dispatch
  def add_string(v)
    MyString.new(v.s + i.to_s)
  end

  # second dispatch: v is MyRational
  def add_rational(v)
    MyRational.new(v.i + (v.j * i), v.j)
  end
end

# new value classes -- avoiding name-conflict with built-in String, Rational
class MyString < Value
  attr_reader :s

  def initialize(s)
    @s = s
  end

  def eval
    self
  end

  def to_string
    s
  end

  def contains_zero
    false
  end

  def no_neg_constants
    self
  end

  # first dispatch: now know self is MyString
  def add_values(v)
    v.add_string self
  end

  # second dispatch: v is Int
  # 'add' in opposite order due to self flipping Values with double dispatch
  def add_int(v)
    MyString.new(v.i.to_s + s)
  end

  # second dispatch: v is MyString
  # 'add' in opposite order due to self flipping Values with double dispatch
  def add_string(v)
    MyString.new(v.s + s)
  end

  # second dispatch: v is MyRational
  # 'add' in opposite order due to self flipping Values with double dispatch
  def add_rational(v)
    MyString.new("#{v.i}/#{v.j}#{s}")
  end
end

class MyRational < Value
  attr_reader :i, :j

  def initialize(i, j)
    @i = i
    @j = j
  end

  def eval
    self
  end

  def to_string
    "#{i}/#{j}"
  end

  def contains_zero
    i.zero?
  end

  def no_neg_constants
    if i.negative? && j.negative?
      MyRational.new(-i, -j)
    elsif j.negative?
      Negate.new(MyRational.new(i, -j))
    elsif i.negative?
      Negate.new(MyRational.new(-i, j))
    else
      self
    end
  end

  # first dispatch: now know self is MyRational
  def add_values(v)
    v.add_rational self
  end

  # second dispatch: v is Int
  # commutative: reuse computation
  def add_int(v)
    v.add_rational self
  end

  # second dispatch: v is MyString
  # 'add' in opposite order due to self flipping Values with double dispatch
  def add_string(v)
    MyString.new("#{v.s}#{i}/#{j}")
  end

  # second dispatch: v is MyRational
  # 'add' in opposite order due to self flipping Values with double dispatch
  def add_rational(v)
    MyRational.new(i * v.j + j * v.i, j * v.j)
  end
end

class Negate < Exp
  attr_reader :e

  def initialize(e)
    @e = e
  end

  def eval
    Int.new(-e.eval.i) # assumes e.eval is Int, no error checking
  end

  def to_string
    "-(#{e.to_string})"
  end

  def contains_zero
    e.contains_zero
  end

  def no_neg_constants
    Negate.new(e.no_neg_constants)
  end
end

class Add < Exp
  attr_reader :e1, :e2

  def initialize(e1, e2)
    @e1 = e1
    @e2 = e2
  end

  def eval
    e1.eval.add_values e2.eval
  end

  def to_string
    "(#{e1.to_string} + #{e2.toString})"
  end

  def contains_zero
    e1.contains_zero || e2.contains_zero
  end

  def no_neg_constants
    Add.new(e1.no_neg_constants, e2.no_neg_constants)
  end
end

class Mult < Exp
  attr_reader :e1, :e2

  def initialize(e1, e2)
    @e1 = e1
    @e2 = e2
  end

  def eval
    Int.new(e1.eval.i * e2.eval.i) # assumes e#.eval is Int, no error checking
  end

  def to_string
    "(#{e1.to_string} * #{e2.to_string})"
  end

  def contains_zero
    e1.contains_zero || e2.contains_zero
  end

  def no_neg_constants
    Mult.new(e1.no_neg_constants, e2.no_neg_constants)
  end
end
