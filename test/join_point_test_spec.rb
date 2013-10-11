require_relative '../src/join_point/join_point_arity'
require_relative '../src/join_point/join_point_class'
require_relative '../src/join_point/join_point_class_hierarchy'
require_relative '../src/join_point/join_point_method'
require_relative '../src/join_point/join_point_parameter_name'
require_relative '../src/join_point/join_point_parameter_type'
require_relative '../src/join_point/join_point_regex_method'
require 'rspec'

describe 'Test de join points' do

  before(:all) do
   class AClass
     def a_method(param1,param2)
     end
   end

    class AnotherClass < AClass
      def another_method
      end
    end

   @_jp_class_hierarchy_aclass = JoinPointClassHierarchy.new(AClass)
   @_jp_method_amethod = JoinPointMethod.new(:a_method)
   @_jp_param_name_param1 = JoinPointParameterName.new(:param1)
   @_jp_regex_only_letters = JoinPointRegexMethod.new /^([a-zA-Z_]+|\[\])[\?!=]?$/
  end

  it 'pasa si la aridad es la especificada' do
    jp_arity_2 = JoinPointArity.new(2)
    expect(jp_arity_2.applies(:a_method,AClass)).to eq(true)
  end

  it 'pasa si la aridad es distinta a la especificada' do
    jp_arity_3 = JoinPointArity.new(3)
    expect(jp_arity_3.applies(:a_method,AClass)).to eq(false)
  end

  it 'pasa si la clase es la especificada' do
    jp_class = JoinPointClass.new(AClass)
    expect(jp_class.applies(nil,AClass)).to eq(true)
  end

  it 'pasa si la clase es distinta a la especificada' do
    jp_class = JoinPointClass.new(AnotherClass)
    expect(jp_class.applies(nil,AClass)).to eq(false)
  end

  it 'pasa si la clase esta dentro de la jerarquia especificada' do
    expect(@_jp_class_hierarchy_aclass.applies(nil,AnotherClass)).to eq(true)
  end

  it 'pasa si la clase esta dentro de la jerararquia especificada y es esa misma' do
    expect(@_jp_class_hierarchy_aclass.applies(nil,AClass)).to eq(true)
  end

  it 'pasa si la clase no esta dentro de la jerarquia especificada' do
    class ANewClass
    end

    jp_class_hieararchy = JoinPointClassHierarchy.new(ANewClass)
    expect(jp_class_hieararchy.applies(nil,AClass)).to eq(false)
  end

  it 'pasa si el metodo es el especificado' do

    expect(@_jp_method_amethod.applies(:a_method,AClass)).to eq(true)
  end

  it 'pasa si el metodo no es el especificado' do
    expect(@_jp_method_amethod.applies(:another_method,AnotherClass)).to eq(false)
  end

  it 'pasa si el metodo tiene al menos un parametro con nombre como el especificado' do
    expect(@_jp_param_name_param1.applies(:a_method,AClass)).to eq(true)
  end

  it 'pasa si el metodo no tiene un parametro con nombre como el especificado' do
    expect(@_jp_param_name_param1.applies(:another_method,AnotherClass)).to eq(false)
  end

  it 'pasa si se valida la RE de que el nombre del metodo tiene solo letras' do
    expect(@_jp_regex_only_letters.applies(:another_method,AnotherClass)).to eq(true)
  end

end