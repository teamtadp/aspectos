class Counter
  def initialize
    @counter = 0
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