# encoding: UTF-8

module Rosette
  module Queuing
    module ResqueQueue

      autoload :Queue,      'rosette/queuing/resque-queue/queue'
      autoload :Worker,     'rosette/queuing/resque-queue/worker'
      autoload :JobWrapper, 'rosette/queuing/resque-queue/job_wrapper'

    end
  end
end
