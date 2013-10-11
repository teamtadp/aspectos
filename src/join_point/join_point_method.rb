require_relative '../../src/cut_point/abstract_join_point'
class JoinPointMethod < AbstractJoinPoint
  def initialize(a_method_sym)
    @jp_method_sym = a_method_sym
  end

  def applies(a_method, a_class)  # Q un metodo sea igual a otro es q sus nombres sean iguales?
    @jp_method_sym.eql?(a_method.name) and
        (a_class.instance_methods.include?(a_method.name) or a_class.methods.include?(a_method.name))
  end
end