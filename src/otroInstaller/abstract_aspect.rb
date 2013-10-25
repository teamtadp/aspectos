class AbstractAspect
  attr_reader :point_cut
  attr_accessor :instead_of_defined

  def initialize(point_cut)
    @point_cut = point_cut
    @instead_of_defined = false
    startup
  end

  def check_point_cut(a_method,a_class)
    @point_cut.applies a_method, a_class
  end

  def instead_of_defined?
    @instead_of_defined
  end

  def startup; end
  def before; end
  def after; end
  def on_error exception; end
  def instead_of instance; end
end