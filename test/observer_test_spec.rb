require_relative '../src/aspect/aspect'
require_relative '../src/cut_point/abstract_join_point'
require_relative '../src/observer/method_observer'

require 'rspec'

describe 'Test de observer' do

  before(:all) do
    #se que no tendria q pasar un asbtract point, pero no arme ninguna clase que lo implemente todavia.
    @aspect1 = Aspect.new AbstractJoinPoint.new
    @aspect2 = Aspect.new AbstractJoinPoint.new
    @aspect3 = Aspect.new AbstractJoinPoint.new
  end


  it 'pasa si la se pudieron agregar los aspectos al singleton' do
    MethodObserver.get_instance.add_aspect @aspect1
    MethodObserver.get_instance.add_aspect @aspect2
    MethodObserver.get_instance.add_aspect @aspect3
    expect(MethodObserver.get_instance.aspects.count == 3)
  end

  it 'pasa si la se pudieron quitar 2 aspects del singleton' do
    MethodObserver.get_instance.remove_aspect @aspect2
    MethodObserver.get_instance.remove_aspect @aspect3
    expect(MethodObserver.get_instance.aspects.count == 1)
  end

  it 'pasa si la se pudieron quitar todos' do
    MethodObserver.get_instance.add_aspect @aspect1
    MethodObserver.get_instance.add_aspect @aspect2
    MethodObserver.get_instance.remove_all
    expect(MethodObserver.get_instance.aspects.count == 0)
  end

end