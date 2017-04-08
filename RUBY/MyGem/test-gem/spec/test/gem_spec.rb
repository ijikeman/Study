require 'spec_helper'

describe Test::Gem do
  it 'has a version number' do
    expect(Test::Gem::VERSION).not_to be nil
  end

  it '#hello' do
    expect(Test::Gem.hello).to eq  nil
  end

  it '#Client.new' do
    client = Test::Gem::Client.new('00-9999-8888', 'Osaka')
    expect(client.name).to eq 'hanako'
    expect(client.tel).to eq '00-9999-8888'
    expect(client.address).to eq 'Osaka'
  end
end
