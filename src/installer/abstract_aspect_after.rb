require_relative 'abstract_aspect'
class AbstractAspectAfter  < AbstractAspect

  def apply_concrete_aspect_method(aspect,m_with_aspect,m_without_aspect,a_class,a_method)
    a_class.send(:define_method, m_with_aspect) do |*parameters|
      result = self.send(m_without_aspect.to_sym, *parameters)
      aspect.after_method(a_class,a_method,result,*parameters)
    end
  end

    def after_method(a_class,a_method,result,*parameters); raise 'after_method must be implemented' end     #esto es lo q tiene q definir el usuario
end