require_relative '../src/cut_point/abstract_join_point'
require_relative '../src/otroInstaller/abstract_aspect'
require_relative 'counter'
require_relative '../src/join_point/join_point_class'
require_relative '../src/otroInstaller/installer'

require 'rspec'

describe 'Test de observer' do

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
    end
  end

  instalador = Installer.new

  after do
    instalador.rollback_all
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

    instalador.add_aspect aspect
    instalador.inject_method(Prueba, :hola)

    prueba = Prueba.new
    prueba.hola

    expect(aspect.counter.result).to eq(2)
  end

  it 'pasa si imprime antes y despues si el metodo tiene un argumento' do

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

    instalador.add_aspect aspect
    instalador.inject_method(Prueba, :imprimi)

    prueba = Prueba.new
    prueba.imprimi 'Chau'

    expect(aspect.counter.result).to eq(2)
  end

  it 'pasa si imprime antes y despues si el metodo tiene un argumento de tipo bloque' do

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

    instalador.add_aspect aspect
    instalador.inject_method(Prueba, :ejecuta)

    prueba = Prueba.new
    prueba.ejecuta do
      'Chau'
    end

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

    instalador.add_aspect aspect
    instalador.inject_method(Prueba, :hola)

    prueba = Prueba.new
    prueba.send :hola

    #Para que funcione, la cuenta que tendria que hacer es 1 * 3 + 1 = 4, a diferencia de (1 + 1) * 3 = 6 si funciona al revez
    expect(aspect.counter.result).to eq(4)
  end

  it "pasa si recibe todos los aspectos que pasasn un joinpoint" do

    class Aspecto < AbstractAspect

    end

    aspect = Aspecto.new(JoinPointClass.new(Prueba))

    instalador.add_aspect aspect
    expect(instalador.aspects_which_apply(:hola, Prueba)).to eq(instalador.aspects)
  end

  it "pasa si guarda la clase y metodo aspecteada" do

    class Aspecto < AbstractAspect

    end

    aspect = Aspecto.new(JoinPointClass.new(Prueba))

    instalador.add_aspect aspect
    instalador.inject_method(Prueba, :hola)

    expect(instalador.injections.keys).to eq([[Prueba, :hola, :hola_without_aspect]])
  end

  it 'pasa si hace rollback de un injection' do

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

    instalador.add_aspect aspect
    instalador.inject_method(Prueba, :hola)

    instalador.rollback(Prueba, :hola)

    prueba = Prueba.new
    prueba.hola

    expect(aspect.counter.result).to eq(0)
  end


end
