require_relative '../../src/observer/class_aspects'

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
  def add_aspects(a_class,a_aspects)
    @aspects << (ClassAspects.new a_class,a_aspects)
    a_class.class_eval do
      if (!self.instance_methods.map{|method| method.to_s}.include?'old_send')
        alias :old_send :send
        def send(method,*args)
         MethodObserver.get_instance.call_before_method(method, self, (MethodObserver.get_instance.get_aspects(self)))
          self.old_send method, *args
         MethodObserver.get_instance.call_after_method(method, self,(MethodObserver.get_instance.get_aspects(self)))
        end
      end
    end
  end

  def remove_aspect(aspect)
    @aspects.delete(aspect)
  end

  def remove_all
    @aspects.clear
  end

  def call_before_method(a_method,a_class, a_aspects)
    a_aspects.each do |aspect|
      aspect.before_method a_method, a_class
    end
  end

  def call_after_method(a_method,a_class, a_aspects)
    a_aspects.each do |aspect|
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

  def get_aspects a_class
    @aspects.each {|class_aspects| class_aspects.aspects_class == a_class}[0].aspects
  end

  def destroy
    @aspects.clear
  end

end