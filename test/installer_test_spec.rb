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
    instalador.remove_all
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

    a = Prueba.new

    aspect = Aspecto.new(CutPointOr.new([JoinPointMethod.new(a.method(:to_s)),JoinPointMethod.new(a.method(:hola))]))

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

  it 'pasa si cachea el error correctamente' do

    class Aspecto < AbstractAspect
      attr_accessor :counter

      def startup
        @counter = Counter.new
      end

      def after; end
      def before; end

      def on_error exeption
        @counter.add
        puts "Atrape el error"
      end
    end

    aspect = Aspecto.new(JoinPointClass.new(Prueba))

    instalador.add_aspect aspect
    instalador.inject_method(Prueba, :generate_error)

    prueba = Prueba.new
    prueba.generate_error

    expect(aspect.counter.result).to eq(1)
  end

  it 'pasa si atrapa el error correctamente' do

    class Aspecto < AbstractAspect
      attr_accessor :counter

      def startup
        @counter = Counter.new
      end

      def after; end
      def before; end
      def on_error; end

      def instead_of(instance)
        instance.multiply 3
      end

    end

    aspect = Aspecto.new(JoinPointMethod.new(:add))
    aspect.instead_of_defined = true


    instalador.add_aspect aspect
    instalador.inject_method(Counter, :add)

    contador = Counter.new(1)
    contador.add

    expect(contador.result).to eq(3)
  end

  it 'pasa si cachea bien un metodo' do
    class AspectoCacheado < CacheableAspect
      attr_accessor :counter

      def startup
        @counter = Counter.new
      end

      def after; puts 'hola'; end
      def before; end
      def on_error; end

    end

    aspect = AspectoCacheado.new(JoinPointClass.new(Calculadora))

    instalador.add_aspect aspect
    instalador.inject_method(Calculadora, :tres)

    calcu = Calculadora.new
    expect(calcu.tres).to eq(3)

    calcu.send :instance_eval do
      def tres_without_aspect
        4
      end
    end

    expect(calcu.tres).to eq(3)

  end
end
