# encoding: UTF-8

require 'redis'
require 'resque'
require 'resque-scheduler'
require 'rosette/queuing'

module Rosette
  module Queuing
    module ResqueQueue

      class Queue < Rosette::Queuing::Queue
        JobWrapper = ::Rosette::Queuing::ResqueQueue::JobWrapper

        attr_reader :configurator

        def initialize(configurator)
          @configurator = configurator
          Resque.redis = Redis.new(configurator.queue_options)
        end

        def enqueue(job)
          if job.delay > 0
            enqueue_with_delay(job)
          else
            enqueue_without_delay(job)
          end
        end

        protected

        def enqueue_with_delay(job)
          Resque.enqueue_in_with_queue(
            queue_from_job(job), job.delay, JobWrapper, args_for(job)
          )
        end

        def enqueue_without_delay(job)
          Resque.enqueue_to(
            queue_from_job(job), JobWrapper, args_for(job)
          )
        end

        def args_for(job)
          { 'klass' => job.class.name, 'args' => job.to_args }
        end

        def queue_from_job(job)
          queue = job.respond_to?(:queue) ? job.queue : nil
          queue ||= job.class.queue
          queue
        end
      end

    end
  end
end
