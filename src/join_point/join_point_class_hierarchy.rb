require_relative '../join_point/abstract_join_point'
class JoinPointClassHierarchy < AbstractJoinPoint
  #Determina si está dentro de la misma jerarquía teniendo en cuenta un nivel
  def initialize(a_superclass)
     @jp_superclass = a_superclass
  end

  def applies(a_method,a_class)
    @jp_superclass.eql?(a_class) or a_class.superclass.eql?(@jp_superclass)
  end
end