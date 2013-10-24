require_relative '../cut_point/abstract_join_point'
class AbstractAspect
  attr_accessor(:cut_point)

  def initialize(cut_point)
    @cut_point = cut_point
  end

  def apply(a_method,a_class)
    if cut_point.applies(a_method,a_class)
      apply_aspect_method(a_method,a_class)
    end
  end

  def apply_aspect_method(a_method,a_class); raise 'apply_aspect_method must be implemented' end
end