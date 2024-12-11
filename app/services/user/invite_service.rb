# frozen_string_literal: true

class User
  class InviteService < ApplicationService
    attr_reader :errors

    def initialize(inviter:, invite_params:)
      @inviter = inviter
      @invite_params = invite_params
      @errors = []

      super()
    end

    def call
      user = create_user
      return false unless user

      send_invite(user)
      true
    end

    private

    def create_user
      user = User.new(@invite_params.except(:survey_id).merge(role: 'employee', company: @inviter.company))
      return user if user.save

      @errors.concat(user.errors.full_messages)
      nil
    end

    def send_invite(user)
      User::InviteResponseService.call(user.id, @invite_params[:survey_id])
    end
  end
end
