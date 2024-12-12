# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:trade_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:website_facebook) }
    it { is_expected.to validate_presence_of(:business_description) }

    describe 'associations' do
      it { is_expected.to have_many(:users).dependent(:destroy) }
      it { is_expected.to have_many(:surveys).dependent(:destroy) }
    end
  end
end
