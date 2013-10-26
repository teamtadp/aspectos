require_relative '../src/join_point/join_point_class'
require_relative '../src/installer/abstract_aspect_before'
require_relative '../src/installer/observe_method_def_after_aspect'
require_relative '../src/installer/aspect_installer'
require 'rspec'

describe 'Debe instalar metodos creados dinamicamente' do
  before(:all) do

    class UnaClase
      def method1
        self.class.send(:define_method,'method2') do
         'method2 defined'
        end
      end
    end

    class Aspecto < AbstractAspectBefore
      attr_accessor :counter

      def initialize(cut_point)
        @cut_point = cut_point
        @counter = 0
      end

      def before_method(a_class,a_method,an_instance,*params)
        puts 'before'
        @counter = @counter + 1
      end
    end

    join_point = JoinPointClass.new(UnaClase)
    join_points = Array.new
    @aspect_before = Aspecto.new(join_point)
    aspects = Array.new
    aspects << @aspect_before
    @classes = Array.new
    @classes << UnaClase
    installer = AspectInstaller.new
    installer.install_clases_with_aspects @classes,aspects
  end

  it 'should do something' do
    prueba = UnaClase.new
    #expect(@aspect_before.counter).to eq(0)
    prueba.method1
    #expect(@aspect_before.counter).to eq(1)
    prueba.method2
    #expect(@aspect_before.counter).to eq(2)
  end
end