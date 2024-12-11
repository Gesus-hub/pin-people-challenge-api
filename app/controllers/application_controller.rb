# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Serializable

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Registro não encontrado.' }, status: :not_found
  end
end
