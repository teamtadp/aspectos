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

  def apply_aspect_method(a_method, a_class)
    aspect = self
    m_with_aspect = a_method.to_s + '_aspect_' + self.class.name
    m_without_aspect = a_method.to_s + '_without_aspect_' + self.class.name
    parameters = a_method.parameters

    apply_concrete_aspect_method(a_class, aspect, m_with_aspect, m_without_aspect)

    a_class.send(:alias_method, m_without_aspect.to_sym, a_method.name)
    a_class.send(:alias_method, a_method.name, m_with_aspect.to_sym)
  end

  def apply_concrete_aspect_method(a_class,aspect,m_with_aspect,m_without_aspect); raise 'apply_concrete_method should be implemented' end

end