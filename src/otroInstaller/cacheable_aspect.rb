require_relative 'abstract_aspect'

class CacheableAspect < AbstractAspect

  def initialize(point_cut)
    @point_cut = point_cut
    @instead_of_defined = false
    startup
    @cache = Hash.new
  end

  def cacheable
    true
  end

  def has_result(key)
    @cache.key?(key)
  end

  def get_result(key)
    return @cache[key]
  end

  def set_result(key, result)
    @cache = @cache.merge(key => result)
  end

  def generate_key(a_class, a_method, params)
    [a_class, a_method, params]
  end


end