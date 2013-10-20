require_relative '../aspect/abstract_aspect'
class Aspect < AbstractAspect
  def after
    puts 'Hola'
  end

end