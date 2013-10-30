class Installer
  attr_reader :injections, :before_aspects, :after_aspects, :error_aspects, :instead_aspects

  def initialize
    @before_aspects = []
    @after_aspects = []
    @error_aspects = []
    @instead_aspects = []
    @injections = Hash.new
  end

  def inject_method(a_class, a_method)
    if (!already_injected?(a_class, a_method))  then
      after_blocks = map_blocks @after_aspects
      before_blocks = map_blocks @before_aspects
      error_blocks = map_blocks @error_aspects
      instead_blocks = map_blocks @instead_aspects

      without = new_symbol(a_method)
      with = a_method
      with_instead_of = instead_blocks.size != 0

      a_class.send(:alias_method, without, with)
      a_class.send :define_method, with do |*args, &block|
        return_thing = self

        before_blocks.each do |aspect|
          aspect.call
        end


        if (with_instead_of) then
          instead_blocks.each do |aspect|
            return_thing = aspect.call self
          end
        else
          begin

            return_thing = self.send without, *args, &block

          rescue Exception => e
            error_blocks.each do |aspect|
              aspect.call e
            end
          end
        end

        after_blocks.each do |aspect|
          aspect.call
        end

        return return_thing
      end

      save_injection(a_class, a_method, without)

    end
  end

  def new_symbol(a_method)
    "#{a_method.to_s}_without_aspect".to_sym
  end

  def with_instead_of?
    @aspects.any? do |aspect|
      aspect.instead_of_defined?
    end
  end

  def save_injection(a_class, original_method, aliased)
    @injections = @injections.merge(generate_key(a_class, original_method) => [aliased, @before_aspects, @after_aspects, @instead_aspects, @error_aspects])
  end


  def rollback(a_class, a_method)
    without = new_symbol(a_method)
    with = a_method
    a_class.send(:alias_method, with, without)
    a_class.send(:remove_method, without)
    @injections.delete(generate_key(a_class, a_method))
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

  def install *classes
    un_metodo_aspecteado = false
    classes.each do |a_class|
      a_class.instance_methods(false).each do |a_method|
        if check_all_aspects(a_method, a_class) then
          inject_method(a_class, a_method)
          un_metodo_aspecteado = true
        end
      end
    end

    raise 'Alguno de los aspectos no aplica' unless un_metodo_aspecteado

  end

  #--------------- METODOS PARA COLECCIONES DE BLOQUES ----------------
  #----- Se puede pensar en tirar las 4 colecciones a otra clase ----
  def install_before(join_point, &block)
    @before_aspects << [join_point, block]
  end
  def install_after(join_point, &block)
    @before_aspects << [join_point, block]
  end
  def install_instead_of(join_point, &block)
    @before_aspects << [join_point, block]
  end
  def install_on_error(join_point, &block)
    @before_aspects << [join_point, block]
  end

  def check_aspect(a_method, a_class, tupla)
    tupla[0].applies a_method, a_class
  end

  def check_aspect_in_collection (a_method, a_class, coleccion)
    coleccion.all? do |tupla|
      check_aspect(a_method, a_class, tupla)
    end
  end

  def check_all_aspects(a_method, a_class)
    check_aspect_in_collection(a_method, a_class,@before_aspects) or
        check_aspect_in_collection(a_method, a_class,@after_aspects) or
        check_aspect_in_collection(a_method, a_class,@error_aspects) or
        check_aspect_in_collection(a_method, a_class,@instead_aspects)
  end

  def map_blocks(colection)
    colection.map do |tupla|
      tupla[1]
    end
  end
end