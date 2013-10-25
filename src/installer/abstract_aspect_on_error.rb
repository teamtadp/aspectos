require_relative 'abstract_aspect'

class AbstractAspectOnError < AbstractAspect
  def apply_concrete_aspect_method(a_class, aspect, m_with_aspect, m_without_aspect)
    a_class.send(:define_method, m_with_aspect) do |*parameters|
      begin
      self.send(m_without_aspect.to_sym, *parameters)
      rescue
      aspect.on_error_method(*parameters)
      end
    end
  end

  def on_error_method(*parameters); raise 'on_error_method must be implemented' end     #esto es lo q tiene q definir el usuario
end