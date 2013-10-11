require_relative '../../src/cut_point/abstract_join_point'
class JoinPointBlock < AbstractJoinPoint

  def initialize(&a_proc)
    @jp_proc = a_proc
  end

  def applies(a_method,a_class)
    @jp_proc.call(a_method,a_class)
  end
end