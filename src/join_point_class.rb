class JoinPointClass

  def initialize(a_class)
    @jp_class = a_class
  end

  def applies(a_method,a_class,a_message)
    @jp_class.send(a_message,a_class)
  end
end