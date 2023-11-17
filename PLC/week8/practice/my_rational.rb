# string expression interpolation: use double quotes and #{...} inside as code
# - "#{exp}strconst"

class MyRational
  attr_reader :num, :den
  protected :num, :den

  def initialize(num, den = 1)
    if den.zero?
      raise 'MyRational denominator must not be 0'
    elsif den.negative?
      @num = - num
      @den = - den
    else
      @num = num
      @den = den
    end

    reduce
  end

  def to_s
    den_s = den == 1 ? '' : "/#{den}"
    "#{num}#{den_s}"
  end

  # add to self
  def add!(r)
    @num = (r.num * den) + (r.den * num)
    @den = r.den * den
    reduce
    self
  end

  # functional addition: syntactic sugar for r1 + r2 -> new obj
  def +(other)
    ans = MyRational.new(num, den)
    ans.add!(other)
  end

  private

  def gcd(x, y)
    if x == y
      x
    elsif x < y
      gcd(x, y - x)
    else
      gcd(y, x)
    end
  end

  def reduce
    if num.zero?
      @den = 1
    else
      d = gcd(num.abs, den)
      @num = num / d
      @den = den / d
    end
  end
end

def use_rationals
  r1 = MyRational.new(3, 4)
  r2 = r1 + r1 + MyRational.new(-5, 2)
  puts r2
  (r2.add! r1).add!(MyRational.new(1, -4))
  puts r2
end

# Not good style generally but can extend existing objects
# - will apply to existing object instances of this class!
#   - existing objects will also use overriden methods - always uses current class definition
# - can apply to ANY class, even built-ins!
class MyRational
  def double
    self + self
  end
end
