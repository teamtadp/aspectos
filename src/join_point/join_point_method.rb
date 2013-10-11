require_relative '../../src/cut_point/abstract_cut_point'
class JoinPointMethod < AbstractCutPoint
  def initialize(a_method)
    @jp_method = a_method
  end

  def applies(a_method, a_class)  # Q un metodo sea igual a otro es q sus nombres sean iguales?
    @jp_method.to_s.eql?(a_method.to_s) and a_class.instance_methods(false).include?(a_method)
  end
end