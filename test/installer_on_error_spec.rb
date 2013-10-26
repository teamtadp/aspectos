require_relative '../src/installer/abstract_aspect'
require_relative '../src/installer/abstract_aspect_on_error'
require_relative '../src/installer/aspect_installer'
require_relative '../src/join_point/join_point_class'
require 'rspec'

describe 'Funciona si se installa el aspecto on error' do

  before(:all) do
    class ClassAspected
      def method0
        1/0
      end

      def method1(num)
        num
      end

      def method2(num1, num2)
        num1 + num2
      end
    end

    class Aspecto < AbstractAspectOnError
      attr_accessor :counter

      def on_error_method(a_class,a_method,*params)
        puts 'error'
      end

    end

    join_point = JoinPointClass.new(ClassAspected)
    join_points = Array.new
    join_points << join_point
    @aspect_before = Aspecto.new(join_point)
    aspects = Array.new
    aspects << @aspect_before
    @classes = Array.new
    @classes << ClassAspected
    installer = AspectInstaller.new
    installer.install_clases_with_aspects @classes,aspects
  end

  it 'should do something' do
    prueba = ClassAspected.new
    prueba.method0
  end
end