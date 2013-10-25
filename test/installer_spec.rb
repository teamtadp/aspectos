require 'rspec'
require_relative "../src/installer/aspect_before"
require_relative "../src/installer/aspect_installer"
require_relative "../src/join_point/join_point_regex_method"
require_relative "../src/cut_point/cut_point_and"


describe 'Funciona se se instala el aspect beforer' do

  before(:all) do
    class ClassApected
      def m
        puts 'Se ejecutó el método m'
      end
    end
  end

  it 'should do something' do
    class Aspecto < AspectBefore
      attr_accessor :counter

      def before_method
        @counter =  1
        puts "Se ejecutó el before."
      end

     end
    joinPoint = JoinPointRegexMethod.new /^([a-zA-Z_]+|\[\])[\?!=]?$/
    joinPoints = Array.new
    joinPoints << joinPoint
    aspect = Aspecto.new(CutPointAnd.new(joinPoints))
    aspects = Array.new
    aspects << aspect
    classes = Array.new
    classes << ClassApected
    installer = AspectInstaller.new
    installer.install_clases_with_aspects classes,aspects

    prueba = ClassApected.new

    prueba.m

    expect(aspect.counter).to eq(1)
   end

end