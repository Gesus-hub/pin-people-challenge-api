# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password_digest) }

    describe '#role' do
      let!(:user) { create(:user) }

      it 'validates inclusion of role' do
        expect(User::ROLES.values).to include(user.role)
      end
    end

    describe '#status' do
      it { is_expected.to define_enum_for(:status).with_values(User::STATUSES) }
    end

    describe '#email' do
      context 'when already exists' do
        context 'and user is not deleted' do
          subject { build_stubbed(:user, email: 'user@pinpeople.com.br') }

          before { create(:user, email: 'user@pinpeople.com.br') }

          it { is_expected.not_to validate_uniqueness_of(:email).ignoring_case_sensitivity }
        end

        context 'and user is discarded' do
          subject { create(:user, email: 'user@pinpeople.com.br') }

          before { create(:user, email: 'user@pinpeople.com.br').discard }

          it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
        end
      end
    end
  end
end
