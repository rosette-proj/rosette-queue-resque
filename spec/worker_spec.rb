# encoding: UTF-8

require 'spec_helper'

include Rosette::Queuing::ResqueQueue

describe Worker do
  let(:rosette_config) do
    Rosette.build_config do |config|
      config.use_error_reporter(Rosette::Core::BufferedErrorReporter.new)
    end
  end

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

    it 'reports errors' do
      expect(Rake::Task['resque:work']).to(
        receive(:invoke).and_raise(RuntimeError)
      )

      worker.start
      expect(rosette_config.error_reporter.errors.size).to eq(1)
    end
  end

  describe '#start_worker' do
    let(:worker) { Worker.new(rosette_config, logger) }

    it 'tells resque to start processing jobs' do
      expect(Rake::Task['resque:work']).to receive(:invoke)
      worker.start_worker
    end

    it 'reports errors' do
      expect(Rake::Task['resque:work']).to(
        receive(:invoke).and_raise(RuntimeError)
      )

      worker.start_worker
      expect(rosette_config.error_reporter.errors.size).to eq(1)
    end
  end

  describe '#start_scheduler' do
    let(:worker) { Worker.new(rosette_config, logger) }

    it 'tells resque to start processing jobs' do
      expect(Rake::Task['resque:scheduler']).to receive(:invoke)
      worker.start_scheduler
    end

    it 'reports errors' do
      expect(Rake::Task['resque:scheduler']).to(
        receive(:invoke).and_raise(RuntimeError)
      )

      worker.start_scheduler
      expect(rosette_config.error_reporter.errors.size).to eq(1)
    end
  end
end
