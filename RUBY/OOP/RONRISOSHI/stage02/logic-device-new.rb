class LogicDevice
  def initialize
    @input = []
  end

  def set_input(idx = 0, value)
    if check_zero_one(value)
      raise ArgumentError, "0か1のみを入力してください"
    end
    @input[idx] = value
  end

  def get_input(idx = 0)
    compute_output(idx)
  end

  private
  def check_zero_one(b)
    if b != 0 && b != 1
      return TRUE
    end
  end

  def compute_output(idx)
  end
end
