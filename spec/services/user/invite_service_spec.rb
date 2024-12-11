# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::InviteService, type: :service do
  subject { described_class.new(inviter:, invite_params:) }

  let(:inviter) { create(:user, :with_company, role: 'admin') }
  let(:survey) { create(:survey, company: inviter.company) }
  let(:invite_params) do
    {
      email: 'invitee@example.com',
      name: 'Test User',
      password: 'password123',
      survey_id: survey.id
    }
  end

  describe '#call' do
    context 'when user creation is successful' do
      it 'calls InviteResponseService and returns true' do
        allow(User::InviteResponseService).to receive(:call)

        expect(subject.call).to be(true)
        expect(User::InviteResponseService).to have_received(:call).with(anything, survey.id)
      end
    end

    context 'when user creation fails' do
      let(:invite_params) { { email: nil, name: nil, password: nil, survey_id: survey.id } }

      it 'returns false and adds errors' do
        expect(subject.call).to be(false)
        expect(subject.errors).to include('Email não pode ficar em branco')
      end
    end
  end
end
