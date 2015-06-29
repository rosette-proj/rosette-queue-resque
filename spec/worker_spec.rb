# encoding: UTF-8

require 'spec_helper'

include Rosette::Queuing::ResqueQueue

describe Worker do
  let(:rosette_config) { :rosette_config }
  let(:logger) { NullLogger.new }

  describe '#initialize' do
    it 'assigns job wrapper config' do
      worker = Worker.new(rosette_config, logger)
      expect(JobWrapper.rosette_config).to eq(rosette_config)
      expect(JobWrapper.logger.object_id).to eq(logger.object_id)
    end

    it 'assigns redis config' do
      worker = Worker.new(rosette_config, logger, {
        redis: { foo: :bar }
      })

      expect(Resque.logger.object_id).to eq(logger.object_id)
    end
  end

  describe '#start' do
    let(:worker) { Worker.new(rosette_config, logger) }

    it 'tells resque to start processing jobs' do
      expect(Rake::Task['resque:work']).to receive(:invoke)
      worker.start
    end
  end

  describe '#start_worker' do
    let(:worker) { Worker.new(rosette_config, logger) }

    it 'tells resque to start processing jobs' do
      expect(Rake::Task['resque:work']).to receive(:invoke)
      worker.start_worker
    end
  end

  describe '#start_scheduler' do
    let(:worker) { Worker.new(rosette_config, logger) }

    it 'tells resque to start processing jobs' do
      expect(Rake::Task['resque:scheduler']).to receive(:invoke)
      worker.start_scheduler
    end
  end
end
