require_relative '../src/cut_point/abstract_join_point'
require_relative '../src/otroInstaller/abstract_aspect'
require_relative 'counter'
require_relative '../src/join_point/join_point_class'
require_relative '../src/join_point/join_point_method'
require_relative '../src/cut_point/cut_point_or'
require_relative '../src/cut_point/cut_point_not'
require_relative '../src/otroInstaller/installer'
require_relative '../src/otroInstaller/cacheable_aspect'

require 'rspec'

describe 'Test de Installer' do

  before do
    class Prueba
      def hola
        puts 'Imprimo hola de la clase prueba'
      end
      def imprimi str
        puts str
      end
      def ejecuta &bloque
        bloque.call
      end
      def generate_error
        raise "Soy un error!"
      end
    end

    class Calculadora
      def tres
        return 3
      end
    end

  end

  instalador = Installer.new

  after do
    instalador.rollback_all
  end

  it 'pasa si imprime antes y despues' do


    counter = Counter.new

    instalador.install_before(JoinPointClass.new(Prueba)) do
      counter.add
    end

    instalador.install(Prueba)

    prueba = Prueba.new
    prueba.hola

    expect(counter.result).to eq(1)
  end

end
