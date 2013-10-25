require_relative '../../src/cut_point/abstract_join_point'
#require 'regex'
class JoinPointRegexMethod < AbstractJoinPoint
  def initialize(a_regex_pattern)
    @jp_a_regex_pattern = a_regex_pattern
  end
  def applies(a_method,a_class)
    #Si preguntas por a_class.instance_method(a_method).to_s.match @a_regex_pattern o  a_regex_pattern.match a_class.instance_method(a_method).to_s
    #no funciona, hay que ver pq es, pero de esta forma anda joya.
    # NO SE ASUSTEN PQ MARCA EL .match EN ROJO!!, funciona igual
    (a_class.instance_methods.include?(a_method) || a_class.methods.include?(a_method.to_s))&&
        (@jp_a_regex_pattern.match a_method.to_s) != nil
  end
end