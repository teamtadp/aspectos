class AspectCollector
  attr_reader :before_aspects, :after_aspects, :error_aspects, :instead_aspects

  def initialize
    @before_aspects = []
    @after_aspects = []
    @error_aspects = []
    @instead_aspects = []
    @checked = Hash.new
  end

  def add_before(join_point, &block)
    @before_aspects << [join_point, block]
    add_check_list([join_point, block])
  end
  def add_after(join_point, &block)
    @after_aspects << [join_point, block]
    add_check_list([join_point, block])
  end
  def add_instead_of(join_point, &block)
    @instead_aspects << [join_point, block]
    add_check_list([join_point, block])
  end
  def add_on_error(join_point, &block)
    @error_aspects << [join_point, block]
    add_check_list([join_point, block])
  end

  def add_check_list(tupla)
    @checked = @checked.merge(tupla => false)
  end

  def after_blocks(a_class, a_method)
    map_blocks(@after_aspects, a_class, a_method)
  end

  def before_blocks(a_class, a_method)
    map_blocks(@before_aspects, a_class, a_method)
  end

  def on_error_blocks(a_class, a_method)
    map_blocks(@error_aspects, a_class, a_method)
  end

  def instead_of_blocks(a_class, a_method)
    map_blocks(@instead_aspects, a_class, a_method)
  end

  def check_aspect(a_method, a_class, tupla)
    if(!was_checked(tupla)) then
      if aspect_apply(a_method, a_class, tupla) then
        set_check(tupla)
      end
    end
  end

  def set_check(tupla)
    @checked[tupla] = true
  end

  def was_checked(tupla)
    @checked[tupla]
  end

  def check_collection(a_method, a_class, coleccion)
    coleccion.each do |tupla|
      check_aspect(a_method, a_class, tupla)
    end
  end

  def check_all_aspects(a_method, a_class)
    check_collection(a_method, a_class,@before_aspects)
    check_collection(a_method, a_class,@after_aspects)
    check_collection(a_method, a_class,@error_aspects)
    check_collection(a_method, a_class,@instead_aspects)
  end

  def all_aspects?
    @checked.values.all? do |tof|
      tof
    end
  end

  def map_blocks(colection, a_class, a_method)
    col = colection.select do |tupla|
      aspect_apply(a_method, a_class, tupla)
    end

    col.map do |tupla|
      tupla[1]
    end
  end

  def aspect_apply(a_method, a_class, tupla)
    tupla[0].applies(a_class.instance_method(a_method), a_class)
  end

  def any_aspect_from?(a_method, a_class, coleccion)
    coleccion.any? do |tupla|
      aspect_apply(a_method, a_class, tupla)
    end
  end

  def any_aspect?(a_method, a_class)
    any_aspect_from?(a_method, a_class,@before_aspects) or
    any_aspect_from?(a_method, a_class,@after_aspects) or
    any_aspect_from?(a_method, a_class,@error_aspects) or
    any_aspect_from?(a_method, a_class,@instead_aspects)
  end

end