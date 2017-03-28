require './logic-device'

class Not < LogicDevice
  private
  def compute_output(idx)
    if @input[idx] == 1
      0
    else
      1
    end
  end
end
