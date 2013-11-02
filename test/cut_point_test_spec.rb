require_relative '../src/cut_point/cut_point_and'
require_relative '../src/cut_point/cut_point_or'
require_relative '../src/cut_point/cut_point_not'
require_relative 'mock_join_point_false'
require_relative 'mock_join_point_true'

require 'rspec'

describe 'Test de cut point' do

  before(:all) do
    @_jp_true_1 = MockJoinPointTrue.new
    @_jp_true_2 = MockJoinPointTrue.new
    @_jp_true_3 = MockJoinPointTrue.new

    @_jp_false_1 = MockJoinPointFalse.new
    @_jp_false_2= MockJoinPointFalse.new
    @_jp_false_3 = MockJoinPointFalse.new
  end

  #---------------------- AND -----------------------
  it 'pasa si el mock true devuelve true' do
    expect(MockJoinPointTrue.new.applies(nil,nil)).to eq(true)
  end

  it 'pasa si el mock false devuelve false' do
    expect(MockJoinPointFalse.new.applies(nil,nil)).to eq(false)
  end
  #--------------------------------------------------

  #---------------------- AND -----------------------
  it 'pasa si todos los join point son verdaderos AND' do
    cp_and = CutPointAnd.new(@_jp_true_1,@_jp_true_2, @_jp_true_3)
    expect(cp_and.applies(nil,nil)).to eq(true)
  end

  it 'pasa si alguno de los join point son falsos AND' do
    cp_and = CutPointAnd.new(@_jp_true_1,@_jp_true_2, @_jp_false_3)
    expect(cp_and.applies(nil,nil)).to eq(false)
  end

  it 'pasa si todos los join point son falsos AND' do
    cp_and = CutPointAnd.new(@_jp_false_1,@_jp_false_2, @_jp_false_3)
    expect(cp_and.applies(nil,nil)).to eq(false)
  end

  it 'pasa si el unico join point es verdadero AND' do
    cp_and = CutPointAnd.new(@_jp_true_3)
    expect(cp_and.applies(nil,nil)).to eq(true)
  end

  it 'pasa si el unico join point es falsos AND' do
    cp_and = CutPointAnd.new(@_jp_false_3)
    expect(cp_and.applies(nil,nil)).to eq(false)
  end
  #--------------------------------------------------

  #---------------------- OR -----------------------
  it 'pasa si todos los join point son verdaderos OR' do
    cp_or = CutPointOr.new(@_jp_true_1,@_jp_true_2, @_jp_true_3)
    expect(cp_or.applies(nil,nil)).to eq(true)
  end

  it 'pasa si alguno de los join point son verdadero OR' do
    cp_or = CutPointOr.new(@_jp_true_1,@_jp_false_2, @_jp_false_3)
    expect(cp_or.applies(nil,nil)).to eq(true)
  end

  it 'pasa si todos los join point son falsos OR' do
    cp_or = CutPointOr.new(@_jp_false_1,@_jp_false_2, @_jp_false_3)
    expect(cp_or.applies(nil,nil)).to eq(false)
  end

  it 'pasa si el unico join point es verdadero OR' do
    cp_or = CutPointOr.new(@_jp_true_3)
    expect(cp_or.applies(nil,nil)).to eq(true)
  end

  it 'pasa si el unico join point es falsos OR' do
    cp_or = CutPointOr.new(@_jp_false_3)
    expect(cp_or.applies(nil,nil)).to eq(false)
  end
  #--------------------------------------------------

  #---------------------- NOT -----------------------
  it 'pasa si el join point es verdadero NOT' do
    cp_not = CutPointNot.new(@_jp_true_3)
    expect(cp_not.applies(nil,nil)).to eq(false)
  end

  it 'pasa si el join point es falsos NOT' do
    cp_not = CutPointNot.new(@_jp_false_3)
    expect(cp_not.applies(nil,nil)).to eq(true)
  end
  #--------------------------------------------------

  #----------------- CUTS CON CUTS ------------------
  #--------------------------------------------------
end
