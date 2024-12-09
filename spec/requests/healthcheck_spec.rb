# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Healthcheck' do
  describe 'GET /up' do
    it 'returns HTTP status :ok (200)' do
      get '/up'

      expect(response).to have_http_status(:ok)
    end
  end
end
