require_relative '../join_point/join_point_dsl'

class AbstractJoinPoint
  include JoinPointDsl
  IMPLEMENT_MSG = 'abstract method must be implemented'
  def applies(a_method, a_class); raise IMPLEMENT_MSG end
end