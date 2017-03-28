require 'spec_helper'
require 'factory_girl'
require './cat'

describe Cat do
  before do
    build(:cat)
  end
  it "is named 'Mike'" do
    cat = Cat.new
    expect(cat.name).to eql 'Mike'
  end
end
