require_relative '../src/aspect/aspect'
require_relative '../src/cut_point/abstract_join_point'
require_relative '../src/observer/method_observer'
require_relative 'mock_join_point_true'
require_relative 'mock_join_point_false'

require_relative '../src/join_point/join_point_class'

require 'rspec'

describe 'Test de observer' do

  before(:all) do
    #se que no tendria q pasar un asbtract point, pero no arme ninguna clase que lo implemente todavia.
    @aspect1 = Aspect.new(MockJoinPointTrue.new)
    @aspect2 = Aspect.new(MockJoinPointTrue.new)
    @aspect3 = Aspect.new(MockJoinPointTrue.new)
  end

  it 'prueba de impresion' do
    class Prueba
      def hola
        puts 'Prueba'
      end
    end

    MethodObserver.get_instance.add_aspect(JoinPointClass.new(Prueba))

    Prueba.new.hola
    expect(true)
  end






end