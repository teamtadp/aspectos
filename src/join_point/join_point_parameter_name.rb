require_relative '../../src/cut_point/abstract_join_point'
class JoinPointParameterName < AbstractJoinPoint
  def initialize(a_param_sym)
    @jp_param_sym = a_param_sym
  end

  def applies(a_method,a_class)
    a_method.parameters.any? do |p|
        p[1].eql?(@jp_param_sym)
      end
    end
  end
