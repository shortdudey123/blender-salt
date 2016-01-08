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

  let(:driver_ssl) do
    described_class.new(
      events: Blender::Handlers::Base.new,
      host: 'localhost',
      port: 12345,
      username: 'foo',
      password: 'bar',
      ssl: true
    )
  end

  let(:hosts) {['h1']}

  let(:tasks){ Array.new(3){|n| create_salt_task('test.ping')}}

  let(:client) { SaltClient::Client.new 'http://localhost:12345', 'foo', 'bar' }

  let(:client_ssl) { SaltClient::Client.new 'https://localhost:12345', 'foo', 'bar' }

  it 'execute salt call' do
    allow(SaltClient::Client).to receive(:new).with('http://localhost:12345', 'foo', 'bar').and_return(double('salt'))
    expect(client).to receive(:call).with('h1', 'test.ping', 'test-arguments').exactly(3).times
    driver.execute(tasks, hosts)
  end

  it 'execute salt call via ssl' do
    allow(SaltClient::Client).to receive(:new).with('https://localhost:12345', 'foo', 'bar').and_return(double('salt'))
    expect(client_ssl).to receive(:call).with('h1', 'test.ping', 'test-arguments').exactly(3).times
    driver_ssl.execute(tasks, hosts)
  end

  context 'CLI' do
    it 'salt call' do
      allow(SaltClient::Client).to receive(:new).with('http://localhost:12345', 'foo', 'bar').and_return(double('salt'))
      conn = double('serf connection')
      allow(client).to receive(:call).with('node1', 'test.ping', nil)
      allow(client).to receive(:call).with('node2', 'test.ping', nil)
      allow(client).to receive(:call).with('node3', 'test.ping', nil)
      Blender::CLI.start(%w{-q -f spec/data/example.rb})
    end
  end
end
