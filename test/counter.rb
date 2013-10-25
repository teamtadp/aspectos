class Counter
  def initialize number=0
    @counter = number
  end

  def add
    @counter += 1
  end

  def multiply number
    @counter *= number
  end

  def result
    @counter
  end
end