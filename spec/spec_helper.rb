require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'blender/drivers/salt'
require 'blender/tasks/salt'

module Helper
  def create_salt_task(name)
    Blender::Task::Salt.new(name).tap do |t|
      t.arguments 'test-arguments'
    end
  end
end

RSpec.configure do |config|
  config.include Helper
  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end
