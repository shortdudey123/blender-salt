#
# Author:: Grant Ridder (<shortdudey123@gail.com>)
# Copyright:: Copyright (c) 2015 Grant Ridder
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'salt_client'
require 'blender/exceptions'
require 'blender/log'
require 'blender/drivers/base'

module Blender
  module Driver
    # Salt driver for Blender
    class Salt < Base
      attr_reader :concurrency, :ssl

      def initialize(config = {})
        cfg = config.dup
        @concurrency = cfg.delete(:concurrency) || 1
        @ssl = cfg.delete(:ssl) || false
        super(cfg)
      end

      def salt_call(command, host)
        responses = []
        http_scheme = @ssl ? 'https' : 'http'
        salt_server_url = "#{http_scheme}://#{config[:host]}:#{config[:port]}"
        Log.debug("Invoking sall call '#{command.function}' with arguments "\
                  "'#{command.arguments}' against #{host}")
        Log.debug("Salt server address #{salt_server_url}")
        client = SaltClient::Client.new salt_server_url,
                                        config[:username],
                                        config[:password]

        host.each do |h|
          event = client.call(h, command.function, command.arguments)
          responses << event
          stdout.puts event.inspect
          Log.info("Results for #{command.inspect}: #{event}")
        end
        responses
      end

      def run_command(command, nodes)
        responses = salt_call(command, nodes)
        command.process.call(responses) if command.process
        exit_status(responses, nodes)
      rescue StandardError => e
        ExecOutput.new(-1, '', e.message)
      end

      def exit_status(responses, nodes)
        if responses.size == nodes.size
          ExecOutput.new(0, responses.inspect, '')
        else
          ExecOutput.new(-1, '', 'Insufficient number of responses. '\
                         "Expected:#{nodes.size}, Got:#{responses.size}")
        end
      end

      def execute(tasks, hosts)
        Log.debug("Salt call on [#{hosts.inspect}]")
        tasks.each do |task|
          hosts.each_slice(concurrency) do |nodes|
            cmd = run_command(task.command, nodes)
            if cmd.exitstatus != 0 && !task.metadata[:ignore_failure]
              fail ExecutionFailed, cmd.stderr
            end
          end
        end
      end
    end
  end
end
