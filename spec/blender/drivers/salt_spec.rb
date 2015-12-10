require 'spec_helper'
require 'blender/handlers/base'
require 'blender/cli'

describe Blender::Driver::Salt do
  let(:driver) do
    described_class.new(
      events: Blender::Handlers::Base.new,
      host: 'localhost',
      port: 12345,
      username: 'foo',
      password: 'bar'
    )
  end

  let(:hosts) {['h1']}

  let(:tasks){ Array.new(3){|n| create_salt_task('test.ping')}}

  let(:client) { SaltClient::Client.new 'http://localhost:12345', 'foo', 'bar' }

  before do
    allow(SaltClient::Client).to receive(:new).with('http://localhost:12345', 'foo', 'bar').and_return(double('salt'))
  end

  it 'execute salt call' do
    expect(client).to receive(:call).with('h1', 'test.ping', 'test-arguments').exactly(3).times
    driver.execute(tasks, hosts)
  end

  context 'CLI' do
    it 'salt call' do
      conn = double('serf connection')
      allow(client).to receive(:call).with('node1', 'test.ping', nil)
      allow(client).to receive(:call).with('node2', 'test.ping', nil)
      allow(client).to receive(:call).with('node3', 'test.ping', nil)
      Blender::CLI.start(%w{-q -f spec/data/example.rb})
    end
  end
end
