require_relative 'abstract_aspect'
class AspectBefore < AbstractAspect

  #TODO: se pueden extraer cachos de código en la super clase porq algunas cosas se van a repetir. Template method.
    def apply_aspect_method(a_method,a_class)
      aspect = self
      a_class.send(:define_method, 'm_with_aspect') do #TODO: poner nombre dinmico para m_with_aspect
        aspect.before_method          #TODO: ver como hacer para q el usuario pueda definir parametros (before_method(*params), para q le lleguen))
        self.send(:m_without_aspect)   #TODO: poner nombre dinamico para m_without_aspect (idea, se puede reemplazar la palabra "aspect")
      end
      a_class.send(:alias_method, :m_without_aspect, a_method)
      a_class.send(:alias_method, a_method,'m_with_aspect'.to_sym)
    end

    def before_method; raise 'before_method must be implemented' end     #esto es lo q tiene q definir el usuario
end