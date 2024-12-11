# frozen_string_literal: true

module Api
  module Companies
    class SurveysController < ApplicationController
      before_action :authenticate_user!

      def create
        service = Surveys::CreatorService.new(
          current_user: current_user,
          survey_params: survey_params
        )

        if service.call
          render json: data_serializer(service.survey), status: :created
        else
          render json: { errors: service.errors }, status: :unprocessable_entity
        end
      end

      private

      def survey_params
        params.require(:survey).permit(
          :title,
          questions_attributes: [
            :content,
            :question_type,
            { options_attributes: [:value] }
          ]
        )
      end
    end
  end
end
