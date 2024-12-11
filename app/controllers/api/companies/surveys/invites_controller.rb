# frozen_string_literal: true

module Api
  module Companies
    module Surveys
      class InvitesController < Api::ApplicationController
        def create
          invite_service = User::InviteService.new(
            inviter: current_user,
            invite_params: invite_params
          )

          if invite_service.call
            render json: { message: 'Convite enviado com sucesso.' }, status: :created
          else
            render json: { errors: invite_service.errors }, status: :unprocessable_entity
          end
        end

        private

        def invite_service_class
          User::InviteService
        end

        def invite_params
          params.require(:invite).permit(:email, :survey_id)
        end
      end
    end
  end
end
