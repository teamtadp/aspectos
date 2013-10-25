require 'rspec'
require_relative '../src/installer/abstract_aspect_before'
require_relative '../src/installer/aspect_installer'
require_relative '../src/join_point/join_point_class'
require_relative '../src/cut_point/cut_point_and'


describe 'Funciona se se instala el aspect beforer' do

  before(:all) do
    class ClassAspected
      def method0
      0
      end

      def method1(num)
       num
      end

      def method2(num1, num2)
        num1 + num2
      end
    end

    class Aspecto < AbstractAspectBefore
      attr_accessor :counter

      def before_method(*params)
        @counter = 1
      end

    end

    join_point = JoinPointClass.new(ClassAspected)
    join_points = Array.new
    join_points << join_point
    @aspect = Aspecto.new(CutPointAnd.new(join_points))
    aspects = Array.new
    aspects << @aspect
    classes = Array.new
    classes << ClassAspected
    installer = AspectInstaller.new
    installer.install_clases_with_aspects classes,aspects


  end

  it 'should do something 0' do
    prueba = ClassAspected.new
    res = prueba.method0
    expect(@aspect.counter).to eq(1)
    expect(res).to eq(0)
  end

  it 'should do something 1' do
    prueba = ClassAspected.new
    res = prueba.method1 1
    expect(@aspect.counter).to eq(1)
    expect(res).to eq(1)
  end

  it 'should do something 2' do
    prueba = ClassAspected.new
    res = prueba.method2 1,2
    expect(@aspect.counter).to eq(1)
    expect(res).to eq(3)
  end

end