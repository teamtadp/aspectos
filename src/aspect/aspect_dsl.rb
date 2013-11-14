require_relative '../join_point/join_point_class'
require_relative '../join_point/join_point_method'
require_relative '../join_point/join_point_class_hierarchy'
require_relative '../join_point/join_point_arity'
require_relative '../join_point/join_point_block'
require_relative '../join_point/join_point_parameter_name'
require_relative '../join_point/join_point_parameter_name'
require_relative '../join_point/join_point_parameter_type'
require_relative '../join_point/join_point_regex_class'
require_relative '../join_point/join_point_regex_method'
require_relative '../join_point/join_point_superclass'

class AspectDSL
  def initialize(aspecto)
    @aspecto = aspecto
  end

  def define(&block)
    instance_eval &block
  end

  def after(join_point, &block)
    @aspecto.install_after(join_point, &block)
  end

  def before(join_point, &block)
    @aspecto.install_before(join_point, &block)
  end

  def instead_of(join_point, &block)
    @aspecto.install_instead_of(join_point, &block)
  end

  def on_error(join_point, &block)
    @aspecto.install_on_error(join_point, &block)
  end

  def classes(*classes)
    @classes = classes
  end

  def all_classes
    ObjectSpace.each_object(Class).to_a
  end

  # ---- Definicion de JP ---------

  def for_class(a_class)
    JoinPointClass.new(a_class)
  end

  def for_method(a_method_sym)
    JoinPointMethod.new(a_method_sym)
  end

  def for_arity(an_arity)
    JoinPointArity.new(an_arity)
  end

  def for_block(&a_proc)
    JoinPointBlock.new(&a_proc)
  end

  def for_class_hierarchy(an_ancestor)
    JoinPointClassHierarchy.new(an_ancestor)
  end

  def for_parameter_name(a_param_name)
    JoinPointParameterName.new(a_param_name)
  end

  def for_parameter_type(a_param_type)
    JoinPointParameterType.new(a_param_type)
  end

  def for_regex_class(a_regex)
    JoinPointRegexClass.new(a_regex)
  end

  def for_regex_method(a_regex)
    JoinPointRegexMethod.new(a_regex)
  end

  def for_superclass(a_superclass)
    JoinPointSuperclass.new(a_superclass)
  end
end