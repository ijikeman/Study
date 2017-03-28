require './logic-device-new'

class And < LogicDevice
  private
  def compute_output(idx)
    @input.each do |b|
      return 1 if b == 1
    end
    0
  end
end
