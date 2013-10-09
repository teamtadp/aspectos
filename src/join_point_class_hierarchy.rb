class JoinPointClassHierarchy
  def initialize(a_superclass)
     @jp_superclass = a_superclass
  end

  def applies(a_method,a_class)
    a_class.superclass.eql?(@jp_superclass)
  end
end