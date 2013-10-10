class JoinPointParameterType
  def initialize(a_parameter_type_sym)
    @jp_param_type_sym = a_parameter_type_sym
  end

  def applies(a_method,a_class)
    a_class.instance_method(a_method).parameters.any? do |p|
      p[0].eql?(@jp_param_type_sym)
    end
  end

end