require 'rspec'
require_relative '../src/installer/aspect_before'
require_relative '../src/installer/aspect_installer'
require_relative '../src/join_point/join_point_class'
require_relative '../src/cut_point/cut_point_and'


describe 'Funciona se se instala el aspect beforer' do

  before(:all) do
    class ClassApected
      def method1 num
        puts 'Se ejecuto el metodo m'
      end
    end
  end

  it 'should do something' do
  class Aspecto < AspectBefore
     attr_accessor :counter

     def before_method
       @counter =  1
       puts 'Se ejecuto el before.'
     end

  end
  join_point = JoinPointClass.new(ClassApected)
  join_points = Array.new
  join_points << join_point
  aspect = Aspecto.new(CutPointAnd.new(join_points))
  aspects = Array.new
  aspects << aspect
  classes = Array.new
  classes << ClassApected
  installer = AspectInstaller.new
  installer.install_clases_with_aspects classes,aspects

  prueba = ClassApected.new

  prueba.method1 1

  expect(aspect.counter).to eq(1)
  end

end