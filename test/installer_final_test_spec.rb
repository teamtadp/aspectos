require_relative '../src/cut_point/abstract_join_point'
require_relative '../src/otroInstaller/abstract_aspect'
require_relative 'counter'
require_relative '../src/join_point/join_point_class'
require_relative '../src/join_point/join_point_method'
require_relative '../src/cut_point/cut_point_or'
require_relative '../src/cut_point/cut_point_and'
require_relative '../src/cut_point/cut_point_not'
require_relative '../src/otroInstaller/installer'
require_relative '../src/otroInstaller/cacheable_aspect'

require 'rspec'

describe 'Test de Installer' do
  instalador = nil

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

    instalador = Installer.new
  end


  after do
    instalador.rollback_all
    instalador.clean
  end

  it 'pasa si imprime antes y despues' do


    counter = Counter.new

    instalador.install_before(JoinPointClass.new(Prueba)) do
      counter.add
    end

    instalador.install_after(JoinPointClass.new(Prueba)) do
      counter.add
    end

    instalador.install(Prueba)

    prueba = Prueba.new
    prueba.hola

    expect(counter.result).to eq(2)
  end

  it 'pasa si imprime antes y despues si el metodo tiene un argumento' do

    counter = Counter.new

    instalador.install_before(JoinPointClass.new(Prueba)) do
      counter.add
    end

    instalador.install_after(JoinPointClass.new(Prueba)) do
      counter.add
    end

    instalador.install(Prueba)

    prueba = Prueba.new
    prueba.imprimi 'Chau'

    expect(counter.result).to eq(2)
  end

  it 'pasa si imprime antes y despues si el metodo tiene un argumento' do

    counter = Counter.new

    instalador.install_before(JoinPointClass.new(Prueba)) do
      counter.add
    end

    instalador.install_after(JoinPointClass.new(Prueba)) do
      counter.add
    end

    instalador.install(Prueba)

    prueba = Prueba.new
    prueba.ejecuta do
      'Chau'
    end

    expect(counter.result).to eq(2)
  end

  it 'pasa si primero imprime before y luego imprime after' do

    string = "empieza-"

    instalador.install_after(JoinPointClass.new(Prueba)) do
      string+= "after"
    end

    instalador.install_before(JoinPointClass.new(Prueba)) do
      string+= "before-"
    end


    instalador.install(Prueba)

    prueba = Prueba.new
    prueba.send :hola

    expect(string).to eq("empieza-before-after")
  end

  it "pasa si puede instalar el metodo" do


    instalador.install_before(CutPointAnd.new(JoinPointClass.new(Prueba), JoinPointMethod.new(:hola))) do
    end


    instalador.aspect_collector.check_all_aspects(:hola, Prueba)

    expect(instalador.aspect_collector.all_aspects?).to eq(true)

  end

  it "pasa si no puede instalar el metodo" do
    instalador.install_before(CutPointAnd.new(JoinPointClass.new(Prueba), JoinPointMethod.new(:hola))) do
    end

    instalador.aspect_collector.check_all_aspects(:ejecuta, Prueba)

    expect(instalador.aspect_collector.all_aspects?).to eq(false)

  end

  it "pasa si devuelve un bloque" do
    instalador.install_after(CutPointAnd.new(JoinPointClass.new(Prueba), JoinPointMethod.new(:hola))) do
    end

    expect(instalador.aspect_collector.after_blocks(Prueba, :hola).size).to eq(1)
  end

  it "pasa si devuelve ningun bloque" do
    instalador.install_before(CutPointAnd.new(JoinPointClass.new(Prueba), JoinPointMethod.new(:hola))) do
    end

    expect(instalador.aspect_collector.before_blocks(Prueba, :ejecuta).size).to eq(0)
  end

  it "pasa si guarda la clase y metodo aspecteada" do

    instalador.install_before(CutPointAnd.new(JoinPointClass.new(Prueba), JoinPointMethod.new(:hola))) do
    end

    instalador.install(Prueba)

    expect(instalador.injections.keys).to eq([[Prueba, :hola]])
  end

  it "pasa si instala solo lo que tiene que instalar" do
    counter = Counter.new

    instalador.install_before(JoinPointClass.new(Prueba)) do
      counter.add
    end

    instalador.install_after(JoinPointClass.new(Calculadora)) do
      counter.add
    end

    instalador.install(Prueba,Calculadora)

    Calculadora.new.tres

    expect(counter.result).to eq(1)
  end

  it 'pasa si hace rollback de un injection' do

    counter = Counter.new

    instalador.install_before(JoinPointClass.new(Prueba)) do
      counter.add
    end

    instalador.install_after(JoinPointClass.new(Prueba)) do
      counter.add
    end


    instalador.install(Prueba)

    instalador.rollback(Prueba, :hola)

    prueba = Prueba.new
    prueba.hola

    expect(counter.result).to eq(0)
  end


  it 'pasa si captura el error correctamente' do

    string = ""

    instalador.install_on_error(JoinPointClass.new(Prueba)) do |e|
      string = "Agarre el error: '#{e.to_s}'"
    end

    instalador.install(Prueba)

    prueba = Prueba.new
    prueba.generate_error

    expect(string).to eq("Agarre el error: 'Soy un error!'")
  end

  it 'pasa si hace un instead of' do

    instalador.install_instead_of(JoinPointMethod.new(:add)) do |_self|
      _self.multiply 4
    end

    instalador.install(Counter)

    contador = Counter.new(2)
    contador.add

    expect(contador.result).to eq(8)
  end

  it 'pasa si hace un instead of y devuelve correctamente' do

    instalador.install_instead_of(JoinPointMethod.new(:trabaja)) do |_self|
      'Estoy de paro'
    end

    prueba = Prueba.new

    expect(prueba.trabaja).to eq('Si senor!')

    instalador.install(Prueba)

    expect(prueba.trabaja).to eq('Estoy de paro')
  end


end
