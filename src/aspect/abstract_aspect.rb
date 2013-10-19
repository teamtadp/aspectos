class AbstractAspect

  IMPLEMENT_MSG = 'abstract method must be implemented'

  attr_reader :point_cut

  def initialize(point_cut)
     @point_cut = point_cut
  end

  def before; raise IMPLEMENT_MSG end
  def after; raise IMPLEMENT_MSG end

  def before_method(a_method,a_class)
    if check_point_cut a_method,a_class
       self.before
    end
  end

  def after_method(a_method,a_class)
    if check_point_cut a_method,a_class
      self.after
    end
  end

  def check_point_cut(a_method,a_class)
    @point_cut.applies a_method,a_class
  end
end