# encoding: UTF-8

require 'resque'
require 'rake'
require 'resque/tasks'
require 'resque/scheduler/tasks'
require 'rosette/queuing'
require 'thread'

module Rosette
  module Queuing
    module ResqueQueue

      class Worker < Rosette::Queuing::Worker
        def initialize(rosette_config, logger, options = {})
          @rosette_config = rosette_config
          @logger = logger

          JobWrapper.rosette_config = rosette_config
          JobWrapper.logger = logger

          Resque.logger = logger
          Resque.redis = options.fetch(:redis, {})
        end

        def start
          start_worker
        end

        def start_worker
          Rake::Task['resque:work'].invoke
        end

        def start_scheduler
          Rake::Task['resque:scheduler'].invoke
        end
      end

    end
  end
end
