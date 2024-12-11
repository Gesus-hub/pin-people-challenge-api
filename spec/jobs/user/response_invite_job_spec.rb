# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::ResponseInviteJob do
  let(:user) { create(:user, :with_company) }
  let(:survey) { create(:survey, company: user.company) }

  describe '#perform' do
    context 'when user and survey exist' do
      it 'sends an invitation email' do
        mailer = instance_double(ActionMailer::MessageDelivery)
        allow(UserMailer::ResponseInviteMailer).to receive(:invite)
          .with(user.name, user.email, survey.title, anything)
          .and_return(mailer)
        allow(mailer).to receive(:deliver_now)

        described_class.new.perform(user.id, survey.id)

        expect(UserMailer::ResponseInviteMailer).to have_received(:invite)
        expect(mailer).to have_received(:deliver_now)
      end
    end

    context 'when user or survey does not exist' do
      it 'does not send an email if user is missing' do
        allow(UserMailer::ResponseInviteMailer).to receive(:invite)

        described_class.new.perform(nil, survey.id)

        expect(UserMailer::ResponseInviteMailer).not_to have_received(:invite)
      end

      it 'does not send an email if survey is missing' do
        allow(UserMailer::ResponseInviteMailer).to receive(:invite)

        described_class.new.perform(user.id, nil)

        expect(UserMailer::ResponseInviteMailer).not_to have_received(:invite)
      end
    end
  end
end
