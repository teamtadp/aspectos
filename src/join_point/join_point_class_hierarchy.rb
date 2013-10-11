require_relative '../../src/cut_point/abstract_join_point'
class JoinPointClassHierarchy < AbstractJoinPoint
  #Determina si está dentro de la misma jerarquía teniendo en cuenta todos los niveles
  def initialize(a_superclass)
     @jp_superclass = a_superclass
  end

  def applies(a_method,a_class)
    a_class.ancestors.include?(@jp_superclass)
  end
end