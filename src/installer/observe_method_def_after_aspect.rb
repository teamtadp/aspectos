require_relative 'abstract_aspect_after'
require_relative 'aspect_installer'
class ObserveMethodDefAfterAspect < AbstractAspectAfter

  def initialize(cut_point,old_methods, installer)
    @cut_point = cut_point
    @old_methods = old_methods
    @installer = installer
  end

  def after_method(a_class,a_method,result,*parameters)
    if @old_methods.size < a_class.instance_methods(false).size
      puts 'aspecteando'
      new_methods = Array.new
      new_methods << (a_class.instance_methods(false) - @old_methods)
      new_methods.flatten!
      @installer.new_methods_notified(a_class,new_methods)
    end
    result
  end
end