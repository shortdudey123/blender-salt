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

require 'blender/tasks/base'

module Blender
  module Task
    # Salt blender task
    class Salt < Blender::Task::Base
      SaltCall = Struct.new(:target, :function, :arguments, :process)

      attr_reader :command

      def initialize(name, metadata = {})
        super
        @command = SaltCall.new
        @command.function = name
      end

      def target(t)
        @command.target = t
      end

      def function(f)
        @command.function = f
      end

      def arguments(a)
        @command.arguments = a
      end

      def process(&block)
        @command.process = block if block
      end

      def execute(&block)
        @command.instance_eval(&block)
      end
    end
  end
end
