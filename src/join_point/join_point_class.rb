require_relative '../join_point/abstract_join_point'
class JoinPointClass < AbstractJoinPoint

  def initialize(a_class)
    @jp_class = a_class
  end

  def applies(a_method,a_class)
    @jp_class.eql?(a_class)
  end
end