# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::Companies::Surveys::Invites' do
  let(:user) { create(:user, :with_company) }
  let(:headers) { auth_headers(user) }
  let(:survey) { create(:survey, company: user.company) }
  let(:params) { { invite: { email: email, survey_id: survey.id } } }
  let(:invite_service) { instance_double(User::InviteService) }

  before do
    allow(User::InviteService).to receive(:new).and_return(invite_service)
  end

  describe 'POST /api/companies/:company_id/surveys/:survey_id/invites' do
    context 'when the user is authenticated' do
      before { allow(invite_service).to receive(:call).and_return(success) }

      context 'with valid params' do
        let(:email) { 'invitee@example.com' }
        let(:success) { true }

        it 'sends the invite and returns a success message' do
          post "/api/companies/#{user.company.id}/surveys/#{survey.id}/invites", params: params, headers: headers

          expect(response).to have_http_status(:created)
          expect(json(response.body)).to eq(message: 'Convite enviado com sucesso.')
        end
      end

      context 'with invalid params' do
        let(:email) { '' }
        let(:success) { false }

        before do
          allow(invite_service).to receive(:errors).and_return(['Email não pode ficar em branco'])
        end

        it 'returns an error message' do
          post "/api/companies/#{user.company.id}/surveys/#{survey.id}/invites", params: params, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json(response.body)).to eq(errors: ['Email não pode ficar em branco'])
        end
      end
    end

    context 'when the user is not authenticated' do
      let(:email) { 'invitee@example.com' }

      it 'returns status :unauthorized (401)' do
        post "/api/companies/#{user.company.id}/surveys/#{survey.id}/invites", params: params

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Usuário não logado ou token inválido'])
      end
    end
  end
end
