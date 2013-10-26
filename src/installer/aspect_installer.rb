require_relative '../join_point/join_point_class'
require_relative 'abstract_aspect'
require_relative 'observe_method_def_after_aspect'
class AspectInstaller
  attr_accessor :classes_map

  def initialize
    @classes_map = Hash.new
  end

  def install_clases_with_aspects(some_clases,some_aspects)
    some_clases.each do |c|
      fill_classes_map(c, some_aspects)
      observe_after_asp = ObserveMethodDefAfterAspect.new(JoinPointClass.new(c),c.instance_methods(false),self)
      c.instance_methods(false).each do |m| #TODO:ver esto, para mi habría que agregar c.methods también
        some_aspects.each do |a|
          a.apply(c.instance_method(m),c)
        end
        observe_after_asp.apply(c.instance_method(m),c)
      end
    end
  end

  def fill_classes_map(c, some_aspects)
    unless @classes_map[c.to_s] != nil
      @classes_map[c.to_s] = Array.new
    end
    @classes_map[c.to_s] << some_aspects
    @classes_map[c.to_s].flatten!
  end

  def new_methods_notified(a_class,new_methods)
    puts 'new_methods_notified'
    classes_aspects = @classes_map[a_class.to_s]
    new_methods.each do |m|
      puts 'applying '+ m.to_s
       classes_aspects.each do |a|
         a.apply(a_class.instance_method(m),a_class)
       end
    end
  end

end