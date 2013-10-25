require_relative 'abstract_aspect'
class AbstractAspectBefore < AbstractAspect

  def apply_concrete_aspect_method(a_class, aspect, m_with_aspect, m_without_aspect)
      a_class.send(:define_method, m_with_aspect) do |*parameters|
        aspect.before_method(*parameters)
        self.send(m_without_aspect.to_sym, *parameters)
      end
    end

    def before_method(*parameters); raise 'before_method must be implemented' end     #esto es lo q tiene q definir el usuario
end