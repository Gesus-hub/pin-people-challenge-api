# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:question_type) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:survey) }
  end

  describe 'discard behavior' do
    let(:question) { create(:question) }

    it 'is not discarded by default' do
      expect(question).not_to be_discarded
    end

    it 'can be discarded' do
      question.discard
      expect(question).to be_discarded
    end
  end
end
