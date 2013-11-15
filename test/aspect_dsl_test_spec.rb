require_relative '../src/cut_point/abstract_join_point'
require_relative 'counter'
require_relative '../src/join_point/join_point_class'
require_relative '../src/join_point/join_point_method'
require_relative '../src/cut_point/cut_point_or'
require_relative '../src/cut_point/cut_point_and'
require_relative '../src/cut_point/cut_point_not'
require_relative '../src/aspect/aspect'

require 'rspec'

describe 'Test de Installer' do
  aspect = nil

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

      def trabaja
        "Si senor!"
      end
    end

    class Calculadora
      def tres
        return 3
      end
    end

    aspect = Aspect.new

  end

  after do
    aspect.rollback_all
    aspect.clean
  end

  it 'pasa si imprime antes y despues' do
    counter = Counter.new

    aspect = Aspect.define {
      classes Prueba

      after for_class Prueba do
        counter.add
      end

      before for_class Prueba do
        counter.add
      end
    }

    aspect.install(Prueba)

    prueba = Prueba.new
    prueba.hola

    expect(counter.result).to eq(2)
  end

  it 'pasa si imprime antes y despues si el metodo tiene un argumento' do

    counter = Counter.new

    aspect = Aspect.define {

      after for_method :imprimi do |a_string|
        counter.add
      end

      before for_method :imprimi do |a_string|
        counter.add
      end
    }

    aspect.install(Prueba)

    prueba = Prueba.new
    prueba.imprimi 'Chau'

    expect(counter.result).to eq(2)
  end

  it 'pasa si imprime antes y despues si el metodo tiene un bloque' do

    counter = Counter.new

    aspect = Aspect.define {

      after for_class Prueba do
        counter.add
      end

      before for_class Prueba do
        counter.add
      end

    }

    aspect.install(Prueba)


    prueba = Prueba.new
    prueba.ejecuta do
      'Chau'
    end

    expect(counter.result).to eq(2)
  end

  it 'pasa si primero imprime before y luego imprime after' do

    string = "empieza-"

    aspect = Aspect.define {

      after for_class Prueba do
        string+= "after"
      end

      before for_class Prueba do
        string+= "before-"
      end
    }

    aspect.install(Prueba)

    prueba = Prueba.new
    prueba.send :hola

    expect(string).to eq("empieza-before-after")
  end

  it "pasa si instala solo lo que tiene que instalar" do
    counter = Counter.new(1)

    aspect = Aspect.define {
      after for_class Prueba do
        counter.add
      end

      #Se esta llamando dos veces y no se porque... Despues me fijo
      before for_class Calculadora do
        counter.multiply(10)
      end
    }

    aspect.install(Prueba, Calculadora)


    Calculadora.new.tres

    expect(counter.result).to eq(10)
  end

  it 'pasa si captura el error correctamente' do

    string = "No agarre el error"

    aspect = Aspect.define {

      on_error for_class Prueba do |e|
        string = "Agarre el error: '#{e.to_s}'"
      end
    }

    aspect.install(Prueba)

    prueba = Prueba.new
    prueba.generate_error

    expect(string).to eq("Agarre el error: 'Soy un error!'")
  end

  it 'pasa si hace un instead of' do

    aspect = Aspect.define {

      instead_of for_method :add do |_self|
        _self.multiply 4
      end
    }

    aspect.install(Counter)

    contador = Counter.new(2)
    contador.add

    expect(contador.result).to eq(8)
  end

  it 'pasa si hace un instead of y devuelve correctamente' do

    aspect = Aspect.define {

      instead_of for_method :trabaja do |_self|
        'Estoy de paro'
      end
    }

    aspect.install(Prueba)

    prueba = Prueba.new

    expect(prueba.trabaja).to eq('Estoy de paro')
  end

  it 'pasa si se instala lo correspondiente' do
    class AClass
      attr_accessor :prop
      def initialize
        @prop = ''
      end
      def meth
        @prop += '-meth'
      end
    end
    aspect = Aspect.define {

    before ((for_class AClass and for_method :meth).or for_method :hola) do
      @prop += 'before'
    end

    }

    aspect.install(AClass)
    prueba = AClass.new
    prueba.meth
    expect(prueba.prop).to eq('before-meth')
  end


end
