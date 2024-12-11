# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Survey do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:company) }
  end

  describe 'discard behavior' do
    let(:survey) { create(:survey) }

    it 'is not discarded by default' do
      expect(survey).not_to be_discarded
    end

    it 'can be discarded' do
      survey.discard
      expect(survey).to be_discarded
    end
  end
end
