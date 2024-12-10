# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationService do
  klass = Class.new(ApplicationService) do
    def call
      response.add_result :my_result
      response.add_error :my_error
      response
    end
  end

  subject { klass.new }

  before do
    I18n.backend.store_translations(:'pt-BR', services: { errors: { fake_service: { my_error: 'Meu super error' } } })

    stub_const('FakeService', klass)
  end

  describe '.call' do
    it 'adds call method into subclass' do
      expect(FakeService).to respond_to(:call)
    end

    it 'calls instance`s call method' do
      fake_service_instance = instance_spy(FakeService)
      allow(FakeService).to receive(:new).with(1).and_return(fake_service_instance)

      FakeService.call 1

      expect(FakeService).to have_received(:new).with(1).once
      expect(fake_service_instance).to have_received(:call).once
    end

    it 'returns a response object' do
      expect(subject.call).to be_a(ApplicationService::ResponseService)
    end
  end

  it 'allows adding errors' do
    expect(subject.call.errors).to be_added(:fake_service, :my_error)
  end

  it 'allows verify if it has errors' do
    expect(subject.call).not_to be_ok
  end

  it 'returns the error message' do
    expect(subject.call.errors.full_messages).to eq(['Meu super error'])
  end
end
