require_relative 'abstract_aspect'
class AbstractAspectInsteadOf < AbstractAspect
  def apply_concrete_aspect_method(a_class, aspect, m_with_aspect, m_without_aspect)
    a_class.send(:define_method, m_with_aspect) do |*parameters|
      aspect.instead_of_method(*parameters)
    end
  end

  def instead_of_method(*parameters); raise 'instead_of_method must be implemented' end     #esto es lo q tiene q definir el usuario
end