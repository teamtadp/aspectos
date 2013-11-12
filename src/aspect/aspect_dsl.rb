require_relative '../join_point/join_point_class'
require_relative '../join_point/join_point_method'

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

  def for_method(a_method)
    JoinPointMethod.new(a_method)
  end

end