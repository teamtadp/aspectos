require_relative '../src/cut_point/abstract_join_point'
require_relative '../src/observer/method_observer'
require_relative 'mock_join_point_true'
require_relative 'mock_join_point_false'
require_relative '../src/aspect/abstract_aspect'
require_relative 'counter'

require_relative '../src/join_point/join_point_class'

require 'rspec'

describe 'Test de observer' do

  before(:all) do
    class Prueba
      def hola
        puts 'Imprimo hola de la clase prueba'
      end
    end
  end

  after do
    MethodObserver.get_instance.destroy
  end

  it 'pasa si imprime antes y despues' do

    class Aspecto < AbstractAspect
      attr_accessor :counter

      def startup
        @counter = Counter.new
      end

      def before
        @counter.add
        puts "Pase antes"
      end

      def after
        @counter.add
        puts 'Pase despues!'
      end
    end

    aspect = Aspecto.new(JoinPointClass.new(Prueba))

    MethodObserver.get_instance.add_aspect(aspect)
    prueba = Prueba.new

    prueba.send :hola

    expect(aspect.counter.result).to eq(2)
  end

  it 'pasa si primero imprime before y luego imprime after' do

    class Aspecto < AbstractAspect
      attr_accessor :counter

      def startup
        @counter = Counter.new
        @counter.add
      end

      def before
        @counter.multiply 3
        puts "Pase antes a"
      end

      def after
        @counter.add
        puts 'Pase despues b!'
      end
    end

    aspect = Aspecto.new(JoinPointClass.new(Prueba))

    MethodObserver.get_instance.add_aspect(aspect)
    prueba = Prueba.new

    prueba.send :hola

    #Para que funcione, la cuenta que tendria que hacer es 1 * 3 + 1 = 4, a diferencia de (1 + 1) * 3 = 6 si funciona al revez
    expect(aspect.counter.result).to eq(4)
  end

end