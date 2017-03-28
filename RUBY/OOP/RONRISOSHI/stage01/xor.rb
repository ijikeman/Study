class Xor
  def initialize
    @input = []
  end

  def set_input(idx, value)
    @input[idx] = value
  end

  def get_input
    xor = 0
    @input.each do |b|
      xor += 1 if b == 1
    end

    if xor % 2 == 0
      0
    else
      1
    end
  end
end
