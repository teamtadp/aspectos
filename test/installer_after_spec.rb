require 'rspec'
require_relative '../src/installer/abstract_aspect'
require_relative '../src/installer/abstract_aspect_after'
require_relative '../src/installer/aspect_installer'
require_relative '../src/join_point/join_point_class'

describe 'Funciona si se instala el aspect after' do
  before(:all) do
    class ClassAspected
      def method0
        puts'method0'
      end

      def method1(num)
        num
      end

      def method2(num1, num2)
        num1 + num2
      end
    end

    class Aspecto < AbstractAspectAfter
      attr_accessor :counter

      def after_method(a_class,a_method,*params)
        @counter = params.count
        puts 'after'
      end

    end

    join_point = JoinPointClass.new(ClassAspected)
    join_points = Array.new
    join_points << join_point
    @aspect_after = Aspecto.new(join_point)
    aspects = Array.new
    aspects << @aspect_after
    @classes = Array.new
    @classes << ClassAspected
    installer = AspectInstaller.new
    installer.install_clases_with_aspects @classes,aspects
    end
  it 'should do something' do
    prueba = ClassAspected.new
    prueba.method0                                 #TODO: hacer tests como la gente

  end
end