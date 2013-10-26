require_relative '../installer/abstract_aspect_instead_of'
require_relative 'resultado'
class CacheAspectInsteadOf < AbstractAspectInsteadOf
  attr_accessor :resultado

  def initialize(cut_point,resultado)
    @cut_point = cut_point
    @cache = Hash.new
    @resultado = resultado
  end

  def instead_of_method(a_class,a_method,an_instance,*parameters)
    key = self.generate_key(a_class,a_method,*parameters)
    if @cache.has_key?(key)
      @resultado.valor_resultado = @cache[key]
      @resultado.clase_resultado = self.class.to_s
      @cache[key]
    else
      m_without_aspect = a_method.to_s + '_without_aspect_' + self.class.name
      result = an_instance.send(m_without_aspect.to_sym,*parameters)
      @cache[key] = result
      @resultado.valor_resultado = result
      @resultado.clase_resultado = a_class.to_s
      result
    end
  end

  def generate_key(a_class,a_method,*params)
    key = a_class.name.to_s + a_method.name.to_s
    params.each do |p|
      key = key + p.to_s
    end
    key
  end
end