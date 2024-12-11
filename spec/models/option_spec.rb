# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Option do
  describe 'associations' do
    it { is_expected.to belong_to(:question) }
  end

  describe 'discard behavior' do
    let(:option) { create(:option) }

    it 'is not discarded by default' do
      expect(option).not_to be_discarded
    end

    it 'can be discarded' do
      option.discard
      expect(option).to be_discarded
    end
  end
end
