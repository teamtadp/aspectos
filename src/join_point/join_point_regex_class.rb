require_relative '../../src/cut_point/abstract_join_point'
class JoinPointRegexClass < AbstractJoinPoint
  def initialize(a_regex_pattern)
    @jp_a_regex_pattern = a_regex_pattern
  end
  def applies(a_method,a_class)
    (@jp_a_regex_pattern.match a_class.to_s) != nil
  end
end