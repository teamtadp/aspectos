require_relative 'abstract_aspect'

class AspectInstaller
  def install_clases_with_aspects(some_clases,some_aspects)
    some_clases.each do |c|
      c.instance_methods.each do |m| #ver esto, para mi habría que agregar c.methods también
        some_aspects.each do |a|
          a.apply(c.instance_method(m),c)
        end
      end
    end
  end
end