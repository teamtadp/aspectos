class AbstractAspectAfter  < AbstractAspect

    def apply_aspect_method(a_method,a_class)
      aspect = self
      @method_name = a_method.to_s+"_aspected"
      @method_symbol = @method_name.to_sym
      a_class.send(:define_method, @method_name) do
        self.send(:@method_symbol)
        aspect.before_method
      end
      a_class.send(:alias_method, :@method_symbol, a_method)
      a_class.send(:alias_method, a_method,@method_symbol)
    end

    def before_method; raise 'before_method must be implemented' end     #esto es lo q tiene q definir el usuario
end