require 'blender/salt'
extend Blender::SaltDSL
config(:salt, host: 'localhost', port: 12345, username: 'foo', password: 'bar')

salt_task 'test.ping' do
  members ['node1', 'node2', 'node3']
end
