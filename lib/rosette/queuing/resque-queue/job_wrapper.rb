# encoding: UTF-8

require 'rosette/queuing'

module Rosette
  module Queuing
    module ResqueQueue

      class JobWrapper < Rosette::Queuing::Job
        class << self
          attr_accessor :rosette_config
          attr_accessor :logger

          def perform(options)
            job = get_const_chain(options['klass']).new(*options['args'])
            job.work(rosette_config, logger)
          rescue => e
            rosette_config.error_reporter.report_error(e)
            raise e  # fail the job so it appears in the failed queue
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
