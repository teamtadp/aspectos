
module JoinPointDsl
  def and(another_jp)
    CutPointAnd.new(self, another_jp)
  end

  def or(another_jp)
    CutPointOr.new(self, another_jp)
  end

  def not(a_jp)
    CutPointNot.new(a_jp)
  end

end