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
  class ErrorClass
    def err
      raise "Error"
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
    aspects = Array.new
    aspects << aspect

    MethodObserver.get_instance.add_aspects(Prueba ,aspects)
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
    aspects = Array.new
    aspects << aspect

    MethodObserver.get_instance.add_aspects(Prueba,aspects)
    prueba = Prueba.new

    prueba.send :hola

    #Para que funcione, la cuenta que tendria que hacer es 1 * 3 + 1 = 4, a diferencia de (1 + 1) * 3 = 6 si funciona al revez
    expect(aspect.counter.result).to eq(4)
  end

  it 'pasa si se ejecuta el codigo querido cuando hay un error' do

    class AspectoE < AbstractAspect
      attr_accessor :error

      def startup
      @error
      end

      def before
      end

      def after
      end

      def onError
        @error = "Código ejecutado ante un error"
      end


    end



    aspect = AspectoE.new(JoinPointClass.new(ErrorClass))
    aspects = Array.new
    aspects << aspect

    MethodObserver.get_instance.add_aspects(ErrorClass,aspects)

    error = ErrorClass.new

    error.send error


    expect(aspect.error).to eq("Código ejecutado ante un error")
  end



end