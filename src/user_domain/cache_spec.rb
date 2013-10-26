require_relative 'resultado'
require_relative 'cache_aspect_instead_of'
require_relative '../installer/aspect_installer'
require_relative '../join_point/join_point_method'
require 'rspec'

describe 'cacheo de metodos' do
  before(:all) do

  class Sumador
    def suma(param1,param2)
      param1 + param2
    end
  end

  resultado = Resultado.new
  jp = JoinPointMethod.new('suma')
  classes = Array.new
  classes << Sumador
  aspects = Array.new
  @cache_aspect = CacheAspectInsteadOf.new(jp,resultado)
  aspects << @cache_aspect
  installer = AspectInstaller.new
  installer.install_clases_with_aspects(classes,aspects)

  end

  it 'cuando se ejecuta por segunda vez debe devolver el numero cacheado' do
    sumador = Sumador.new
    sumador.suma(1,2)
    expect(@cache_aspect.resultado.valor_resultado).to eq(3)
    expect(@cache_aspect.resultado.clase_resultado).to eq('Sumador')
    sumador.suma(1,2)
    expect(@cache_aspect.resultado.valor_resultado).to eq(3)
    expect(@cache_aspect.resultado.clase_resultado).to eq('CacheAspectInsteadOf')
  end
end