# DYNAMIC DISPATCH: aka Late Binding or Virtual Methods
# - change behavior of superclass method by overriding methods it calls
# local variables and blocks are mostly lexically scoped
# instance variables, class variables, and methods depend on FULL class definition (self)
# - @var is looked up in self
# - @@var is looked up in self.class
# - methods:
#   - eval obj.method(exp1, exp2, ...) => obj ("receiver"), exp1, exp2 eval like normal
#   - look up method in obj.Class and recurse to check superclasses if not found (error if not found by Object)
#     - mixins complicate this
#   - eval body of method with self bound to obj and params bound to args
#     - THIS IS WHERE THE MAGIC HAPPENS, calls in method on self will look in obj's class first then recurse up!
# concern: may not be intentional to change one method by proxy of changing another!
# - can be hard to reason about what the code does if it depends on other method calls
#   - could use private on the method dependencies but generally not good OOP

class A
  def even(x)
    puts 'in even A'
    x.zero? or odd(x - 1)
  end

  def odd(x)
    puts 'in odd A'
    x.zero? ? false : even(x - 1)
  end
end

a1 = A.new.odd(7)
puts "a1 is #{a1}\n\n"

class B < A
  def even(x)
    puts 'in even B'
    (x % 2).zero?
  end
end

b1 = B.new.odd(7)
puts "b1 is #{b1}\n\n"

class C < A
  def even(x)
    puts 'in even C'
    false
  end
end

c1 = C.new.odd(7)
puts "c1 is #{c1}\n\n"
