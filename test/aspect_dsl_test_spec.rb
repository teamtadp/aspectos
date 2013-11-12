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

      after JoinPointClass.new(Prueba) do
        counter.add
      end

      before JoinPointClass.new(Prueba) do
        counter.add
      end
    }

    prueba = Prueba.new
    prueba.hola

    expect(counter.result).to eq(2)
  end


  it 'pasa si imprime antes y despues si no defino una clase en particular' do

    counter = Counter.new

    aspect = Aspect.define {

      after JoinPointClass.new(Prueba) do
        counter.add
      end

      before JoinPointClass.new(Prueba) do
        counter.add
      end

    }

    prueba = Prueba.new
    prueba.imprimi 'Chau'

    expect(counter.result).to eq(2)
  end


  it 'pasa si imprime antes y despues si el metodo tiene un argumento' do

    counter = Counter.new

    aspect = Aspect.define {

      after JoinPointClass.new(Prueba) do
        counter.add
      end

      before JoinPointClass.new(Prueba) do
        counter.add
      end

      classes Prueba
    }

    prueba = Prueba.new
    prueba.imprimi 'Chau'

    expect(counter.result).to eq(2)
  end

  it 'pasa si imprime antes y despues si el metodo tiene un bloque' do

    counter = Counter.new

    aspect = Aspect.define {

      after JoinPointClass.new(Prueba) do
        counter.add
      end

      before JoinPointClass.new(Prueba) do
        counter.add
      end

      classes Prueba
    }


    prueba = Prueba.new
    prueba.ejecuta do
      'Chau'
    end

    expect(counter.result).to eq(2)
  end

  it 'pasa si primero imprime before y luego imprime after' do

    string = "empieza-"

    aspect = Aspect.define {

      after JoinPointClass.new(Prueba) do
        string+= "after"
      end

      before JoinPointClass.new(Prueba) do
        string+= "before-"
      end

      classes Prueba
    }

    prueba = Prueba.new
    prueba.send :hola

    expect(string).to eq("empieza-before-after")
  end

  it "pasa si instala solo lo que tiene que instalar" do
    counter = Counter.new(1)

    aspect = Aspect.define {

      after JoinPointClass.new(Prueba) do
        counter.add
      end

      #Se esta llamando dos veces y no se porque... Despues me fijo
      before JoinPointClass.new(Calculadora) do
        counter.multiply(10)
      end

      classes Prueba, Calculadora
    }

    aspect.install(Prueba,Calculadora)

    Calculadora.new.tres

    expect(counter.result).to eq(1)
  end

  it 'pasa si captura el error correctamente' do

    string = "No agarre el error"

    aspect = Aspect.define {

      on_error JoinPointClass.new(Prueba) do |e|
        string = "Agarre el error: '#{e.to_s}'"
      end

      classes Prueba
    }

    prueba = Prueba.new
    prueba.generate_error

    expect(string).to eq("Agarre el error: 'Soy un error!'")
  end

  it 'pasa si hace un instead of' do

    aspect = Aspect.define {

      instead_of JoinPointMethod.new(:add) do |_self|
        _self.multiply 4
      end

      classes Counter
    }

    contador = Counter.new(2)
    contador.add

    expect(contador.result).to eq(8)
  end

  it 'pasa si hace un instead of y devuelve correctamente' do

    aspect = Aspect.define {

      instead_of JoinPointMethod.new(:trabaja) do |_self|
        'Estoy de paro'
      end

      classes Prueba
    }

    prueba = Prueba.new

    expect(prueba.trabaja).to eq('Estoy de paro')
  end


end
