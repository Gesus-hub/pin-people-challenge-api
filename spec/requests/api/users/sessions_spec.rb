# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Users::SessionsController' do
  describe 'POST /api/users/sign_in' do
    let(:user) { create(:user, password: '123456') }

    context 'when the user is authenticated' do
      it 'returns HTTP status :ok (200) with user data' do
        post '/api/users/sign_in', params: { user: { email: user.email, password: '123456' } }

        expected_body = {
          data: {
            name: user.name,
            role: user.role,
            email: user.email,
            metadata: {}
          }
        }

        expect(response).to have_http_status(:ok)
        expect(json(response.body)).to eq(expected_body)
      end
    end

    context 'when the user is not found' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        post '/api/users/sign_in', params: { user: { email: 'user@pinpeople.com.br', password: '123456' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Email ou senha incorreto'])
      end
    end

    context 'when the password is incorrect' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        post '/api/users/sign_in', params: { user: { email: user.email, password: '1234567' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Email ou senha incorreto'])
      end
    end

    context 'when the email is blank' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        post '/api/users/sign_in', params: { user: { email: '', password: '123456' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Email ou senha incorreto'])
      end
    end

    context 'when the password is blank' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        post '/api/users/sign_in', params: { user: { email: user.email, password: '' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Email ou senha incorreto'])
      end
    end

    context 'when the email is invalid' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        post '/api/users/sign_in', params: { user: { email: 'user@pinpeople', password: '123456' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Email ou senha incorreto'])
      end
    end

    context 'when the password is invalid' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        post '/api/users/sign_in', params: { user: { email: user.email, password: '123' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Email ou senha incorreto'])
      end
    end

    context 'when the user is not confirmed' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        user.update(confirmed_at: nil)

        post '/api/users/sign_in', params: { user: { email: user.email, password: '123456' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Conta não confirmada'])
      end
    end
  end
end
