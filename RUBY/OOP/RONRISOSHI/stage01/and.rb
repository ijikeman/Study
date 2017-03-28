class And
  def initialize
    @input = []
  end

  def set_input(idx, value)
    @input[idx] = value
  end

  def get_input
    @input.each do |b|
      return 0 if b == 0
    end
    return 1
  end
end
