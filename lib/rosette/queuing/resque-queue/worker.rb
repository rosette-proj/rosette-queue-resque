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
          rosette_config.error_reporting.with_error_reporting do
            Rake::Task['resque:work'].invoke
          end
        end

        def start_scheduler
          rosette_config.error_reporting.with_error_reporting do
            Rake::Task['resque:scheduler'].invoke
          end
        end
      end

    end
  end
end
