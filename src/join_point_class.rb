class JoinPointClass

  def initialize(a_class)
    @jp_class = a_class
  end

  def applies(a_method,a_class)
    @jp_class.eql?(a_class)
  end
end