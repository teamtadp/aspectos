class AbstractAspect

  attr_reader :point_cut

  def initialize(point_cut)
    @debug = 0
    @point_cut = point_cut
    startup
  end

  def after_method(a_method,a_class)
    debug "AFTER", a_method, a_class

    if check_point_cut a_method,a_class
      self.after
    end
  end

  def before_method(a_method,a_class)
    debug "BEFORE", a_method, a_class
    if check_point_cut a_method,a_class
      self.before
    end
  end


  def on_error_method(a_method,a_class)
    debug "ONERROR", a_method, a_class

    if check_point_cut a_method,a_class
      self.onError
    end
  end

  def debug where, a_method,a_class
    puts "#{where.to_s} Class:'#{a_class.class.name}' Method:'#{a_method.to_s}' applies:#{check_point_cut a_method, a_class}" unless @debug == 0
  end

  def check_point_cut(a_method,a_class)
    @point_cut.applies a_method, a_class.class
  end

  def startup; end
  def before; end
  def after; end
  def onError; end
  def insteadOf; end

end