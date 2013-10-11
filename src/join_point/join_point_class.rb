require_relative '../../src/cut_point/abstract_cut_point'
class JoinPointClass < AbstractCutPoint
  def initialize(a_class)
    @jp_class = a_class
  end

  def applies(a_method,a_class)
    a_class.eql?(@jp_class)
  end
end