# encoding: UTF-8

require 'rosette/queuing'
require 'resque-retry'

module Rosette
  module Queuing
    module ResqueQueue

      class JobWrapper < Rosette::Queuing::Job
        # extend Resque::Plugins::Retry

        # retry a max of 3 times, wait 30 seconds between retries
        # @retry_limit = 3
        # @retry_delay = 30

        class << self
          attr_accessor :rosette_config
          attr_accessor :logger

          def perform(options)
            rosette_config.error_reporter.with_error_reporting do
              job = get_const_chain(options['klass']).new(*options['args'])
              job.work(rosette_config, logger)
            end
          end

          private

          # this is necessary because jruby 1.7.x doesn't support namespaced
          # constant lookup, i.e. Foo::Bar::Baz
          def get_const_chain(const_str)
            const_str.split('::').inject(Kernel) do |const, const_chunk|
              const.const_get(const_chunk.to_sym)
            end
          end
        end
      end

    end
  end
end
