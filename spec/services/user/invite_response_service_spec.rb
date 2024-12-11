# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::InviteResponseService, type: :service do
  subject { described_class.new(user.id, survey.id) }

  let(:user) { create(:user, :with_company) }
  let(:survey) { create(:survey, company: user.company) }

  describe '#call' do
    it 'calls ResponseInviteJob' do
      allow(User::ResponseInviteJob).to receive(:perform_now)

      subject.call

      expect(User::ResponseInviteJob).to have_received(:perform_now).with(user.id, survey.id)
    end
  end
end
