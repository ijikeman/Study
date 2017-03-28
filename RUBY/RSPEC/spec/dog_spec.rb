require "spec_helper"
require './dog'

describe Dog do
  it "is named 'Pochi'" do
    dog = Dog.new
    expect(dog.name).to eql 'Pochi'
  end
end
