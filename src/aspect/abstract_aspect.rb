class AbstractAspect

  IMPLEMENT_MSG = "abstract method must be implemented"

  attr_reader :pointCut

  def initialize pointCut
     @pointCut = pointCut
  end

  def before; raise IMPLEMENT_MSG; end
  def after; raise IMPLEMENT_MSG; end

  def before_method(a_method,a_class)
    if check_point_cut a_method,a_class
       before
    end
  end

  def after_method(a_method,a_class)
    if check_point_cut a_method,a_class
      after
    end
  end

  def check_point_cut(a_method,a_class)
    pointCut.aplica_metodo a_method,a_class
  end
end