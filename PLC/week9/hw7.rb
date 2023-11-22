# Expressions in a little language for 2D geometry objects.

class GeometryExpression
  EPSILON = 0.00001
end

class GeometryValue
  private

  # Tests equality for real numbers.
  def real_close(r1, r2)
    (r1 - r2).abs < GeometryExpression::EPSILON
  end

  def real_close_point(x1, y1, x2, y2)
    real_close(x1, x2) && real_close(y1, y2)
  end

  def two_points_to_line(x1, y1, x2, y2)
    return VerticalLine.new(x1) if real_close(x1, x2)

    m = (y2 - y1).to_f / (x2 - x1)
    b = y1 - (m * x1)
    Line.new(m, b)
  end

  public

  def eval_prog(_env)
    self
  end

  def preprocess_prog
    self
  end

  def intersect_no_points(np)
    np
  end

  def intersect_line_segment(seg)
    line_result = intersect(two_points_to_line(seg.x1, seg.y1, seg.x2, seg.y2))
    line_result.intersect_with_segment_as_line_result(seg)
  end
end

class NoPoints < GeometryValue
  def shift(_dx, _dy)
    self
  end

  def intersect(other)
    other.intersect_no_points(self)
  end

  def intersect_point(_p)
    self
  end

  def intersect_line(_line)
    self
  end

  def intersect_vertical_line(_vline)
    self
  end

  def intersect_with_segment_as_line_result(_seg)
    self
  end
end

class Point < GeometryValue
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def shift(dx, dy)
    Point.new(x + dx, y + dy)
  end

  def intersect(other)
    other.intersect_point(self)
  end

  def intersect_point(p)
    real_close_point(x, y, p.x, p.y) ? self : NoPoints.new
  end

  def intersect_line(line)
    real_close(y, (line.m * x) + line.b) ? self : NoPoints.new
  end

  def intersect_vertical_line(vline)
    real_close(x, vline.x) ? self : NoPoints.new
  end

  def intersect_with_segment_as_line_result(seg)
    inbetween(x, seg.x1, seg.x2) && inbetween(y, seg.y1, seg.y2) ? self : NoPoints.new
  end

  private

  def inbetween(v, end1, end2)
    e = GeometryExpression::EPSILON
    v.between?(end1 - e, end2 + e) || v.between?(end2 - e, end1 + e)
  end
end

class Line < GeometryValue
  attr_reader :m, :b

  def initialize(m, b)
    @m = m
    @b = b
  end

  def shift(dx, dy)
    Line.new(m, (b + dy) - (m * dx))
  end

  def intersect(other)
    other.intersect_line(self)
  end

  def intersect_point(p)
    p.intersect_line(self) # commutative
  end

  def intersect_line(line)
    if real_close(m, line.m)
      return real_close(b, line.b) ? self : NoPoints.new
    end

    x = (line.b - b).to_f / (m - line.m)
    y = (m * x) + b
    Point.new(x, y)
  end

  def intersect_vertical_line(vline)
    Point.new(vline.x, (m * vline.x) + b)
  end

  def intersect_with_segment_as_line_result(seg)
    seg
  end
end

class VerticalLine < GeometryValue
  attr_reader :x

  def initialize(x)
    @x = x
  end

  def shift(dx, _dy)
    VerticalLine.new(x + dx)
  end

  def intersect(other)
    other.intersect_vertical_line(self)
  end

  def intersect_point(p)
    p.intersect_vertical_line(self) # commutative
  end

  def intersect_line(line)
    line.intersect_vertical_line(self) # commutative
  end

  def intersect_vertical_line(vline)
    real_close(x, vline.x) ? self : NoPoints.new
  end

  def intersect_with_segment_as_line_result(seg)
    seg
  end
end

class LineSegment < GeometryValue
  attr_reader :x1, :y1, :x2, :y2

  def initialize (x1, y1, x2, y2)
    @x1 = x1
    @y1 = y1
    @x2 = x2
    @y2 = y2
  end

  def preprocess_prog
    return Point.new(x1, y1) if real_close_point(x1, y1, x2, y2)

    if real_close(x1, x2)
      return y1 < y2 ? self : LineSegment.new(x2, y2, x1, y1)
    end

    x1 < x2 ? self : LineSegment.new(x2, y2, x1, y1)
  end

  def shift(dx, dy)
    LineSegment.new(x1 + dx, y1 + dy, x2 + dx, y2 + dy)
  end

  def intersect(other)
    other.intersect_line_segment(self)
  end

  def intersect_point(p)
    p.intersect_line_segment(self) # commutative
  end

  def intersect_line(line)
    line.intersect_line_segment(self) # commutative
  end

  def intersect_vertical_line(vline)
    vline.intersect_line_segment(self) # commutative
  end

  def intersect_with_segment_as_line_result(seg)
    if real_close(x1, x2)
      a, b = y1 < seg.y1 ? [self, seg] : [seg, self]

      return Point.new(a.x2, a.y2) if real_close(a.y2, b.y1)

      return NoPoints.new if a.y2 < b.y1

      return b if a.y2 > b.y2

      return LineSegment.new(b.x1, b.y1, a.x2, a.y2)
    end

    a, b = x1 < seg.x1 ? [self, seg] : [seg, self]

    return Point.new(a.x2, a.y2) if real_close(a.x2, b.x1)

    return NoPoints.new if a.x2 < b.x1

    return b if a.x2 > b.x2

    LineSegment.new(b.x1, b.y1, a.x2, a.y2)
  end
end

class Intersect < GeometryExpression
  def initialize(e1, e2)
    @e1 = e1
    @e2 = e2
  end

  def eval_prog(env)
    @e1.eval_prog(env).intersect(@e2.eval_prog(env))
  end

  def preprocess_prog
    Intersect.new(@e1.preprocess_prog, @e2.preprocess_prog)
  end
end

class Let < GeometryExpression
  def initialize(s, e1, e2)
    @s = s
    @e1 = e1
    @e2 = e2
  end

  def eval_prog(env)
    @e2.eval_prog([[@s, @e1.eval_prog(env)], *env])
  end

  def preprocess_prog
    Let.new(@s, @e1.preprocess_prog, @e2.preprocess_prog)
  end
end

class Var < GeometryExpression
  def initialize(s)
    @s = s
  end

  def eval_prog(env)
    pr = env.assoc @s
    raise 'undefined variable' if pr.nil?

    pr[1]
  end

  def preprocess_prog
    self
  end
end

class Shift < GeometryExpression
  def initialize(dx, dy, e)
    @dx = dx
    @dy = dy
    @e = e
  end

  def eval_prog(env)
    @e.eval_prog(env).shift(@dx, @dy)
  end

  def preprocess_prog
    Shift.new(@dx, @dy, @e.preprocess_prog)
  end
end
