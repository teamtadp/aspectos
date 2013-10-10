class JoinPointParameterName
  def initialize(a_param_sym)
    @jp_param_sym = a_param_sym
  end

  def applies(a_method,a_class)
    a_class.instance_method(a_method).parameters.flatten.include?(@jp_param_sym)
  end

end