require 'spec_helper'
require './dog'

describe Dog do
  it "dog.name = 'pochi'" do
    dog = Dog.new
    expect(dog.name).to eql "Pochi"
  end
end
