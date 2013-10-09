class JoinPointArity
  def initialize(an_arity)
    @jp_arity = an_arity
  end

  def applies(a_method,a_class)
    a_class.instance_method(a_method).arity.eql?(@jp_arity)
  end
end