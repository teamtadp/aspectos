class AspectDSL
  def initialize(aspecto)
    @aspecto = aspecto
    @classes = all_classes
  end

  def define(&block)
    instance_eval &block
    install
  end

  def install
    @aspecto.install(*@classes)
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

end