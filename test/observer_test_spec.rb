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

  end

  it 'prueba de impresion' do
    class Prueba
      def hola
        puts 'Imprimo hola de la clase prueba'
      end
    end

    class Aspecto < AbstractAspect
      attr_accessor :counter

      def startup
        @counter = Counter.new
      end

      def after
        @counter.add
        puts 'Pase por el aspect'
      end

    end

    aspect = Aspecto.new(JoinPointClass.new(Prueba))


    MethodObserver.get_instance.add_aspect(aspect)
    Prueba.new.send :hola

    expect(aspect.counter.result).to eq(1)
  end






end