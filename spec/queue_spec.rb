# encoding: UTF-8

require 'spec_helper'

include Rosette::Queuing::ResqueQueue

describe Queue do
  let(:queue) { Rosette::Queuing::ResqueQueue::Queue.new }
  let(:job) { TestJob.new('foo', 'bar') }

  describe '#enqueue' do
    it 'enqueues a job with resque' do
      expect(Resque).to receive(:enqueue_to).with(
        'testqueue', JobWrapper, {
          'klass' => 'TestJob', 'args' => ['foo', 'bar']
        }
      )

      queue.enqueue(job)
    end
  end

  context 'with delay' do
    let(:delay) { 10 }

    before(:each) do
      job.set_delay(delay)
    end

    it 'enqueues the job with a delay (uses resque-scheduler)' do
      expect(Resque).to receive(:enqueue_in_with_queue).with(
        'testqueue', delay, JobWrapper, {
          'klass' => 'TestJob', 'args' => ['foo', 'bar']
        }
      )

      queue.enqueue(job)
    end
  end
end
