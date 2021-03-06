
require_relative '../src/join_point/join_point_arity'
require_relative '../src/join_point/join_point_class'
require_relative '../src/join_point/join_point_class_hierarchy'
require_relative '../src/join_point/join_point_method'
require_relative '../src/join_point/join_point_parameter_name'
require_relative '../src/join_point/join_point_parameter_type'
require_relative '../src/join_point/join_point_regex_method'
require_relative '../src/join_point/join_point_superclass'
require_relative '../src/join_point/join_point_block'
require_relative '../src/join_point/join_point_regex_class'


require 'rspec'

describe 'Test de join points' do

  before(:all) do
   class AClass
     def a_method(param1,param2)
     end
   end

   @a_method = AClass.instance_method(:a_method)

   class AnotherClass < AClass
      def another_method
      end
    end

   @another_method = AnotherClass.instance_method(:another_method)

   class YetAnotherClass < AnotherClass
     def yet_another_method
     end
   end

   @_jp_class_superclass = JoinPointSuperclass.new(AClass)
   @_jp_class_hierarchy_aclass = JoinPointClassHierarchy.new(AClass)
   @_jp_class_hierarchy_object = JoinPointClassHierarchy.new(Object)
   @_jp_method_amethod = JoinPointMethod.new(:a_method)
   @_jp_param_name_param1 = JoinPointParameterName.new(:param1)
   @_jp_regex_method_name_only_letters = JoinPointRegexMethod.new /^([a-zA-Z_]+|\[\])[\?!=]?$/
   @_jp_regex_class_name_only_letters = JoinPointRegexClass.new /^([a-zA-Z]+|\[\])[\?!=]?$/

  end

  #------------------- ARIDAD ---------------------
  it 'pasa si la aridad es la especificada' do
    jp_arity_2 = JoinPointArity.new(2)
    expect(jp_arity_2.applies(@a_method,AClass)).to eq(true)
  end

  it 'pasa si la aridad es distinta a la especificada' do
    jp_arity_3 = JoinPointArity.new(3)
    expect(jp_arity_3.applies(@a_method,AClass)).to eq(false)
  end
  #------------------------------------------------

  #------------------- NOMBRE CLASE ---------------------
  it 'pasa si la clase es la especificada' do
    jp_class_eql_name = JoinPointClass.new(AClass)
    expect(jp_class_eql_name.applies(nil,AClass)).to eq(true)
  end

  it 'pasa si la clase es distinta a la especificada' do
    jp_class_eql_name = JoinPointClass.new(AnotherClass)
    expect(jp_class_eql_name.applies(nil,AClass)).to eq(false)
  end
  #------------------------------------------------

  #------------------- SUPERCLASE ---------------------
  it 'pasa si la clase esta dentro de la superclase especificada nivel 1' do
    expect(@_jp_class_superclass.applies(nil,AnotherClass)).to eq(true)
  end

  it 'pasa si la clase esta dentro de la superclase especificada y es esa misma nivel 1' do
    expect(@_jp_class_superclass.applies(nil,AClass)).to eq(true)
  end

  it 'pasa si la clase no esta dentro de la superclase especificada nivel 1' do
    class ANewClass
    end

    jp_class_superclass = JoinPointSuperclass.new(ANewClass)
    expect(jp_class_superclass.applies(nil,AClass)).to eq(false)
  end
  #------------------------------------------------


  #------------------- JERARQUIA ---------------------
  it 'pasa si la clase esta dentro de la jerarquia especificada nivel 1' do
    expect(@_jp_class_hierarchy_aclass.applies(nil,AnotherClass)).to eq(true)
  end

  it 'pasa si la clase esta dentro de la jerarquia especificada nivel 2' do
    expect(@_jp_class_hierarchy_aclass.applies(nil,YetAnotherClass)).to eq(true)
  end

  it 'pasa si la clase esta dentro de la jerarquia de object' do
    expect(@_jp_class_hierarchy_object.applies(nil,YetAnotherClass)).to eq(true)
  end

  it 'pasa si la clase esta dentro de la jerararquia especificada y es esa misma' do
    expect(@_jp_class_hierarchy_aclass.applies(nil,AClass)).to eq(true)
  end

  it 'pasa si la clase no esta dentro de la jerarquia especificada todos los niveles' do
    class ANewClass
    end

    jp_class_hieararchy = JoinPointClassHierarchy.new(ANewClass)
    expect(jp_class_hieararchy.applies(nil,AClass)).to eq(false)
  end

  it 'pasa si object no esta en la jerarquia de aclass' do
    expect(@_jp_class_hierarchy_aclass.applies(nil,Object)).to eq(false)
  end
  #------------------------------------------------


  #------------------- NOMBRE METODO ---------------------
  it 'pasa si el metodo es el especificado' do

    expect(@_jp_method_amethod.applies(@a_method,AClass)).to eq(true)
  end

  it 'pasa si el metodo no es el especificado' do
    expect(@_jp_method_amethod.applies(@another_method,AnotherClass)).to eq(false)
  end
  #------------------------------------------------

  #------------------- NOMBRE PARAMETRO ---------------------
  it 'pasa si el metodo tiene al menos un parametro con nombre como el especificado' do
    expect(@_jp_param_name_param1.applies(@a_method,AClass)).to eq(true)
  end

  it 'pasa si el metodo no tiene un parametro con nombre como el especificado' do
    expect(@_jp_param_name_param1.applies(@another_method,AnotherClass)).to eq(false)
  end
  #------------------------------------------------

  #------------------- REGEX METODO ---------------------
  it 'pasa si se valida la RE de que el nombre del metodo tiene solo letras o _' do
    expect(@_jp_regex_method_name_only_letters.applies(@another_method,AnotherClass)).to eq(true)
  end
  it 'pasa si se valida la RE de que el nombre de la clase tiene solo letras' do
    expect(@_jp_regex_class_name_only_letters.applies(@another_method,AnotherClass)).to eq(true)
  end
  #------------------------------------------------

  #------------------- BLOQUE ---------------------
  it 'pasa si se pasa un bloque que chequee la clase tiene el mismo nombre que el metodo' do
    class NombreClase
      def NombreClase
      end
    end
    @_method_nombre_clase = NombreClase.instance_method(:NombreClase)

    @_jp_block = JoinPointBlock.new do
      |a_method, a_class|
      a_method.name.to_s.eql? a_class.to_s
    end

    expect(@_jp_block.applies(@_method_nombre_clase, NombreClase)).to eq(true)
  end
  #------------------------------------------------

end