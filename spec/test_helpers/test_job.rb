# encoding: UTF-8

require 'rosette/queuing'

class TestJob < Rosette::Queuing::Job
  set_queue_name 'testqueue'

  def initialize(arg1, arg2)
    @arg1 = arg1
    @arg2 = arg2
  end

  def to_args
    [@arg1, @arg2]
  end

  def work(rosette_config, logger)
    rosette_config.signal
  end
end
