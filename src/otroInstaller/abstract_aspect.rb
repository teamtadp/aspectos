class AbstractAspect
  attr_reader :point_cut

  def initialize(point_cut)
    @point_cut = point_cut
    startup
  end

  def check_point_cut(a_method,a_class)
    @point_cut.applies a_method, a_class
  end

  def startup; end
  def before; end
  def after; end
  def onError; end
  def insteadOf; end
end