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

    aspect.install_before(JoinPointClass.new(Prueba)) do
      counter.add
    end

    aspect.install_after(JoinPointClass.new(Prueba)) do
      counter.add
    end

    aspect.install(Prueba)

    prueba = Prueba.new
    prueba.hola

    expect(counter.result).to eq(2)
  end

  it 'pasa si imprime antes y despues si el metodo tiene un argumento' do

    counter = Counter.new

    aspect.install_before(JoinPointClass.new(Prueba)) do
      counter.add
    end

    aspect.install_after(JoinPointClass.new(Prueba)) do
      counter.add
    end

    aspect.install(Prueba)

    prueba = Prueba.new
    prueba.imprimi 'Chau'

    expect(counter.result).to eq(2)
  end

  it 'pasa si imprime antes y despues si el metodo tiene un argumento' do

    counter = Counter.new

    aspect.install_before(JoinPointClass.new(Prueba)) do
      counter.add
    end

    aspect.install_after(JoinPointClass.new(Prueba)) do
      counter.add
    end

    aspect.install(Prueba)

    prueba = Prueba.new
    prueba.ejecuta do
      'Chau'
    end

    expect(counter.result).to eq(2)
  end

  it 'pasa si primero imprime before y luego imprime after' do

    string = "empieza-"

    aspect.install_after(JoinPointClass.new(Prueba)) do
      string+= "after"
    end

    aspect.install_before(JoinPointClass.new(Prueba)) do
      string+= "before-"
    end


    aspect.install(Prueba)

    prueba = Prueba.new
    prueba.send :hola

    expect(string).to eq("empieza-before-after")
  end

  it "pasa si puede instalar el metodo" do


    aspect.install_before(CutPointAnd.new(JoinPointClass.new(Prueba), JoinPointMethod.new(:hola))) do
    end


    aspect.aspect_collector.check_all_aspects(:hola, Prueba)

    expect(aspect.aspect_collector.all_aspects?).to eq(true)

  end

  it "pasa si no puede instalar el metodo" do
    aspect.install_before(CutPointAnd.new(JoinPointClass.new(Prueba), JoinPointMethod.new(:hola))) do
    end

    aspect.aspect_collector.check_all_aspects(:ejecuta, Prueba)

    expect(aspect.aspect_collector.all_aspects?).to eq(false)

  end

  it "pasa si devuelve un bloque" do
    aspect.install_after(CutPointAnd.new(JoinPointClass.new(Prueba), JoinPointMethod.new(:hola))) do
    end

    expect(aspect.aspect_collector.after_blocks(Prueba, :hola).size).to eq(1)
  end

  it "pasa si devuelve ningun bloque" do
    aspect.install_before(CutPointAnd.new(JoinPointClass.new(Prueba), JoinPointMethod.new(:hola))) do
    end

    expect(aspect.aspect_collector.before_blocks(Prueba, :ejecuta).size).to eq(0)
  end

  it "pasa si guarda la clase y metodo aspecteada" do

    aspect.install_before(CutPointAnd.new(JoinPointClass.new(Prueba), JoinPointMethod.new(:hola))) do
    end

    aspect.install(Prueba)

    expect(aspect.injections.keys).to eq([[Prueba, :hola]])
  end

  it "pasa si instala solo lo que tiene que instalar" do
    counter = Counter.new

    aspect.install_before(JoinPointClass.new(Prueba)) do
      counter.add
    end

    aspect.install_after(JoinPointClass.new(Calculadora)) do
      counter.add
    end

    aspect.install(Prueba,Calculadora)

    Calculadora.new.tres

    expect(counter.result).to eq(1)
  end

  it 'pasa si hace rollback de un injection' do

    counter = Counter.new

    aspect.install_before(JoinPointClass.new(Prueba)) do
      counter.add
    end

    aspect.install_after(JoinPointClass.new(Prueba)) do
      counter.add
    end


    aspect.install(Prueba)

    aspect.rollback(Prueba, :hola)

    prueba = Prueba.new
    prueba.hola

    expect(counter.result).to eq(0)
  end


  it 'pasa si captura el error correctamente' do

    string = ""

    aspect.install_on_error(JoinPointClass.new(Prueba)) do |e|
      string = "Agarre el error: '#{e.to_s}'"
    end

    aspect.install(Prueba)

    prueba = Prueba.new
    prueba.generate_error

    expect(string).to eq("Agarre el error: 'Soy un error!'")
  end

  it 'pasa si hace un instead of' do

    aspect.install_instead_of(JoinPointMethod.new(:add)) do |_self|
      _self.multiply 4
    end

    aspect.install(Counter)

    contador = Counter.new(2)
    contador.add

    expect(contador.result).to eq(8)
  end

  it 'pasa si hace un instead of y devuelve correctamente' do

    aspect.install_instead_of(JoinPointMethod.new(:trabaja)) do |_self|
      'Estoy de paro'
    end

    prueba = Prueba.new

    expect(prueba.trabaja).to eq('Si senor!')

    aspect.install(Prueba)

    expect(prueba.trabaja).to eq('Estoy de paro')
  end


end
