# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Users::RegistrationsController' do
  describe 'POST /api/users/confirm' do
    let(:user) do
      create(:user, confirmation_token: 'token_confirm', confirmation_sent_at: Time.current, confirmed_at: nil)
    end

    context 'when the user is validating token' do
      it 'returns HTTP status :ok (200) with user data' do
        post '/api/users/confirm', params: { token: user.confirmation_token }

        expected_body = {
          data: {
            id: user.id,
            name: user.name,
            role: user.role,
            email: user.email,
            metadata: {},
            company: nil
          }
        }

        expect(response).to have_http_status(:ok)
        expect(json(response.body)).to eq(expected_body)
      end
    end

    context 'when the token is not found' do
      it 'returns HTTP status :unprocessable_entity (422) with error message' do
        post '/api/users/confirm', params: { token: 'invalid_token' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json(response.body)).to eq(errors: ['Token não encontrado para validação'])
      end
    end

    context 'when the token is expired' do
      it 'returns HTTP status :unprocessable_entity (422) with error message' do
        user.update(confirmation_sent_at: 7.hours.ago)

        post '/api/users/confirm', params: { token: user.confirmation_token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json(response.body)).to eq(errors: ['Token expirado'])
      end
    end

    context 'when the user is already confirmed' do
      it 'returns HTTP status :unprocessable_entity (422) with error message' do
        user.update(confirmed_at: Time.current)

        post '/api/users/confirm', params: { token: user.confirmation_token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json(response.body)).to eq(errors: ['Conta já confirmada'])
      end
    end
  end

  describe 'POST /api/users/sign_up' do
    let(:sign_up_params) do
      {
        name: 'Vinicius Guimaraes',
        email: 'vinicius@pinpeople.com.br',
        password: '123456',
        company: {
          name: 'Glambel',
          trade_name: 'Glambel',
          email: 'glambel@glambel.com.br',
          website_facebook: 'https://glambel.com.br',
          business_description: 'Empresa de beleza'
        }
      }
    end

    context 'when signing up with user and company data' do
      it 'returns HTTP status :created (201) with created user data and company' do
        post '/api/users/sign_up', params: { sign_up: sign_up_params }

        expected_body = {
          data: {
            id: User.last.id,
            name: sign_up_params[:name],
            role: User.last.role,
            email: sign_up_params[:email],
            metadata: {},
            company:
            {
              id: Company.last.id,
              name: sign_up_params[:company][:name],
              trade_name: sign_up_params[:company][:trade_name],
              email: sign_up_params[:company][:email],
              website_facebook: sign_up_params[:company][:website_facebook],
              business_description: sign_up_params[:company][:business_description],
              status: 'active',
              metadata: {},
              discarded_at: nil,
              created_at: Company.last.created_at.as_json,
              updated_at: Company.last.updated_at.as_json
            }
          }
        }

        expect(response).to have_http_status(:created)
        expect(json(response.body)).to eq(expected_body)
      end
    end

    context 'when signing up with only user data' do
      it 'returns HTTP status :created (201) with created user data and no company' do
        post '/api/users/sign_up', params: { sign_up: sign_up_params.except(:company) }

        expected_body = {
          data: {
            id: User.last.id,
            name: sign_up_params[:name],
            role: User.last.role,
            email: sign_up_params[:email],
            metadata: {},
            company: nil
          }
        }

        expect(response).to have_http_status(:created)
        expect(json(response.body)).to eq(expected_body)
      end
    end
  end
end
