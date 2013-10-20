class MethodObserver

  attr_reader :aspects

  def self.get_instance
    @instance == nil ? @instance = new : @instance
  end

  private
  def initialize
    @aspects = Array.new

    Object.class_eval do
      alias :old_send :send

      def send(method,*args)
        MethodObserver.get_instance.call_before_method(method, self)
        self.old_send method, *args
        MethodObserver.get_instance.call_after_method(method, self)
      end
    end


  end

  public
  def add_aspect(aspect)
    @aspects << aspect
  end

  def remove_aspect(aspect)
    @aspects.delete(aspect)
  end

  def remove_all
    @aspects.clear
  end

  def call_before_method(a_method,a_class)
    @aspects.each do |aspect|
      aspect.before_method a_method, a_class
    end
  end

  def call_after_method(a_method,a_class)
    @aspects.each do |aspect|
      aspect.after_method a_method, a_class
    end
  end

  def collect_aspects
    aspects_classes = get_all_class_aspects()
    aspects_classes.each do |aspect|
      add_aspect(aspect.new)
    end
  end

  def get_all_class_aspects
    ObjectSpace.each_object(Class).each do |clase|
      clase.ancestors.include? (AbstractAspect)
    end
  end

  def destroy
    @aspects.clear
  end
end