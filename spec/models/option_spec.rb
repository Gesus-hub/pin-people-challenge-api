# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Option do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:value) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:question) }
  end

  describe 'discard behavior' do
    let(:option) { create(:option) }

    it 'is not discarded by default' do
      expect(option.discarded?).to be_falsey
    end

    it 'can be discarded' do
      option.discard
      expect(option.discarded?).to be_truthy
    end
  end
end
