require_relative 'abstract_aspect'
class AbstractAspectBefore < AbstractAspect

  def apply_concrete_aspect_method(aspect, m_with_aspect, m_without_aspect,a_class,a_method)
      a_class.send(:define_method, m_with_aspect) do |*parameters|
        aspect.before_method(a_class,a_method,self,*parameters)
        self.send(m_without_aspect.to_sym, *parameters)
      end
  end

    def before_method(a_class,a_method,an_instance,*parameters); raise 'before_method must be implemented' end     #esto es lo q tiene q definir el usuario
end