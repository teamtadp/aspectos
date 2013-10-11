require_relative '../../src/cut_point/abstract_join_point'

class JoinPointArity < AbstractJoinPoint
  def initialize(an_arity)
    @jp_arity = an_arity
  end

  def applies(a_method,a_class)
    a_method.arity.eql?(@jp_arity)
  end
end