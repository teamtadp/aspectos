require_relative 'abstract_aspect'
class AbstractAspectBefore < AbstractAspect

  #TODO: se pueden extraer cachos de código en la super clase porq algunas cosas se van a repetir. Template method.
    def apply_aspect_method(a_method,a_class)
      aspect = self
      method_with_aspect = a_method.to_s + '_aspect_' #+ self.class.name
      method_without_aspect = a_method.to_s + '_without_aspect_' #+ self.class.name
      parameters = a_method.parameters

      a_class.send(:define_method, method_with_aspect)  do |*parameters|
         aspect.before_method(*parameters)        #TODO: ver como hacer para q el usuario pueda definir parametros (el metodo del before)(before_method(*params), para q le lleguen))
            self.send(method_without_aspect.to_sym,*parameters)   #TODO hacer q esto pueda recibir parametros (el metodo original)
       end

      a_class.send(:alias_method, method_without_aspect.to_sym, a_method.name)
      a_class.send(:alias_method, a_method.name,method_with_aspect.to_sym)
    end

    def before_method(*parameters); raise 'before_method must be implemented' end     #esto es lo q tiene q definir el usuario
end