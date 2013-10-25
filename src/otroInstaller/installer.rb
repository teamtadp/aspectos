class Installer
  attr_reader :aspects, :injections

  def initialize
    @aspects = []
    @injections = Hash.new
  end

  def inject_method(a_class, a_method)
    without = new_symbol(a_method)
    with = a_method
    aspects = aspects_which_apply a_method, a_class
    if (aspects.length > 0)
      a_class.send(:alias_method, without, with)
      a_class.send :define_method, with do |*args, &block|
        aspects.each do |aspect|
          aspect.before
        end

        self.send without, *args, &block

        aspects.each do |aspect|
          aspect.after
        end
      end

      save_injection(a_class, a_method, without)
    end
  end

  def new_symbol(a_method)
    "#{a_method.to_s}_without_aspect".to_sym
  end

  def save_injection(a_class, original_method, aliased)
    aspectos = aspects_which_apply(original_method, a_class)
    @injections = @injections.merge(generateKey(a_class, original_method, aliased) => aspectos)
  end


  def rollback(a_class, a_method)
    without = new_symbol(a_method)
    with = a_method
    a_class.send(:alias_method, with, without)
    a_class.send(:remove_method, without)
    @injections.delete(generateKey(a_class, a_method, without))
  end

  def generateKey(a_class, a_method, aliased)
    [a_class, a_method, aliased]
  end

  def rollback_all
    @injections.each_key do |key|
      klass=key[0]
      method=key[1]
      rollback klass, method
    end
  end


  def aspects_which_apply a_method, a_class
    return @aspects.select {|aspect| aspect.check_point_cut a_method, a_class}
  end

  def add_aspect aspect
    @aspects << aspect
  end

  def remove_aspect(aspect)
    @aspects.delete(aspect)
  end

  def remove_all
    @aspects.clear
  end

end