# frozen_string_literal: true

class User
  class InviteResponseService < ApplicationService
    attr_reader :user_id, :survey_id

    def initialize(user_id, survey_id)
      @user_id = user_id
      @survey_id = survey_id
      super()
    end

    def call
      User::ResponseInviteJob.perform_now(user_id, survey_id)
    end
  end
end
