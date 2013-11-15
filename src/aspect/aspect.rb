require_relative 'aspect_collector'
require_relative 'aspect_dsl'

class Aspect
  attr_reader :injections, :aspect_collector

  def initialize
    @aspect_collector = AspectCollector.new
    @injections = Hash.new
  end

  def self.define(&block)
    aspecto = Aspect.new
    AspectDSL.new(aspecto).define(&block)
    aspecto
  end

  def inject_method(a_class, a_method)
    if (!already_injected?(a_class, a_method) and @aspect_collector.any_aspect?(a_method, a_class))  then
      after_blocks = @aspect_collector.after_blocks(a_class, a_method)
      before_blocks = @aspect_collector.before_blocks(a_class, a_method)
      error_blocks = @aspect_collector.on_error_blocks(a_class, a_method)
      instead_blocks = @aspect_collector.instead_of_blocks(a_class, a_method)

      without_aspect_method = new_symbol(a_method)
      with_aspect_method = "#{a_method.to_s}_with_aspect".to_sym
      original_method = a_method
      with_instead_of = instead_blocks.size != 0


      a_class.send :define_method, with_aspect_method do |*args, &block|
        return_thing = self


        before_blocks.each do |aspect|
          self.instance_exec(*args,&aspect)
        end


        if (with_instead_of) then
          instead_blocks.each do |aspect|
            return_thing = self.instance_exec(self,*args,&aspect)
          end
        else
          begin

            return_thing = self.send without_aspect_method, *args, &block

          rescue Exception => e
            error_blocks.each do |aspect|
              self.instance_exec(e,*args,&aspect)
            end
          end
        end

        after_blocks.each do |aspect|
          self.instance_exec(*args,&aspect)
        end

        return return_thing
      end
      a_class.send(:alias_method, without_aspect_method, original_method)
      a_class.send(:alias_method, original_method, with_aspect_method)

      save_injection(a_class, a_method, without_aspect_method)

    end
  end

  def new_symbol(a_method)
    "#{a_method.to_s}_without_aspect".to_sym
  end

  def save_injection(a_class, original_method, aliased)
    @injections = @injections.merge(generate_key(a_class, original_method) => [aliased, @aspect_collector])
  end


  def rollback(a_class, a_method)
    without = new_symbol(a_method)
    with = a_method
    a_class.send(:alias_method, with, without)
    a_class.send(:remove_method, without)
    @injections.delete(generate_key(a_class, a_method))
  end

  def clean
    @aspect_collector = AspectCollector.new
  end

  def generate_key(a_class, a_method)
    [a_class, a_method]
  end

  def rollback_all
    @injections.each_key do |key|
      klass=key[0]
      method=key[1]
      rollback klass, method
    end
  end

  def already_injected?(a_class, a_method)
    @injections.key?(generate_key(a_class, a_method))
  end

  def install(*classes)
    do_to_all_methods(*classes) do |a_class, a_method|
      @aspect_collector.check_all_aspects(a_method, a_class)
    end

    raise "Alguno de los aspectos no aplica." unless @aspect_collector.all_aspects?

    do_to_all_methods(*classes) do |a_class, a_method|
        inject_method(a_class, a_method)
    end
  end


  def do_to_all_methods(*classes, &block)
    classes.each do |a_class|
      a_class.instance_methods(false).each do |a_method|
        block.call(a_class, a_method)
      end
    end
  end


  def install_before(join_point, &block)
    @aspect_collector.add_before(join_point, &block)
  end

  def install_after(join_point, &block)
    @aspect_collector.add_after(join_point, &block)
  end

  def install_instead_of(join_point, &block)
    @aspect_collector.add_instead_of(join_point, &block)
  end

  def install_on_error(join_point, &block)
    @aspect_collector.add_on_error(join_point, &block)
  end


end