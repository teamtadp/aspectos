class MethodObserver

  attr_reader :aspects

  def self.get_instance
    @instance == nil ? @instance = new : @instance
  end

  private
  def initialize
    @aspects = Array.new
  end

  public
  def add_aspect(aspect)
    @aspects << aspect
  end

  def remove_aspect aspect
    @aspects.delete(aspect)
  end

  def remove_all
    @aspects.clear
  end

  def call_before_method(a_method,a_class)

  end
  def call_after_method(a_method,a_class)

  end
  def collect_aspects(a_method,a_class)

  end
end