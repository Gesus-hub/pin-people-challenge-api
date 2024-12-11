# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Response do
  describe 'associations' do
    it { is_expected.to belong_to(:survey) }
    it { is_expected.to belong_to(:question) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:value) }

    it do
      create(:response)
      expect(subject).to validate_uniqueness_of(:user_id)
        .scoped_to(:survey_id)
        .ignoring_case_sensitivity
        .with_message(
          I18n.t(
            'activerecord.errors.models.response.attributes.user_id.already_responded'
          )
        )
    end
  end

  describe 'scopes' do
    let!(:active_response) { create(:response) }
    let!(:discarded_response) { create(:response, discarded_at: Time.current) }

    it '.active returns responses without discarded_at' do
      expect(described_class.active).to include(active_response)
      expect(described_class.active).not_to include(discarded_response)
    end

    it '.discarded returns responses with discarded_at' do
      expect(described_class.discarded).to include(discarded_response)
      expect(described_class.discarded).not_to include(active_response)
    end
  end

  describe 'uniqueness validation' do
    let(:user) { create(:user) }
    let(:survey) { create(:survey) }
    let(:question) { create(:question, survey: survey) }

    it 'ensures a user cannot respond to the same survey twice' do
      create(:response, user: user, survey: survey, question: question)
      duplicate_response = build(:response, user: user, survey: survey, question: question)

      expect(duplicate_response).not_to be_valid
      expect(duplicate_response.errors[:user_id]).to include(
        I18n.t(
          'activerecord.errors.models.response.attributes.user_id.already_responded'
        )
      )
    end
  end
end
