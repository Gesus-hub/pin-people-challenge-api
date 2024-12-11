# frozen_string_literal: true

module Api
  module Companies
    module Surveys
      class ResponsesController < Api::ApplicationController
        before_action :set_survey, only: :create

        def create
          service = ::Responses::CreatorService.new(
            current_user: current_user,
            survey: @survey,
            response_params: response_params
          )

          if service.call
            render json: { message: 'Resposta salva com sucesso.' }, status: :created
          else
            render json: { errors: service.errors }, status: :unprocessable_entity
          end
        end

        private

        def set_survey
          @survey = Survey.find(params[:survey_id])
        rescue ActiveRecord::RecordNotFound
          render json: { errors: ['Survey não encontrada.'] }, status: :not_found
        end

        def response_params
          params.require(:response).permit(
            :user_id,
            :survey_id,
            :question_id,
            :value
          )
        end
      end
    end
  end
end
