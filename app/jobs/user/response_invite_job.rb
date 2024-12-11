# frozen_string_literal: true

class User
  class ResponseInviteJob < ApplicationJob
    queue_as :mailers

    def perform(user_id, survey_id)
      @user = User.find_by(id: user_id)
      @survey = Survey.find_by(id: survey_id)

      return if @user.nil? || @survey.nil?

      send_invitation_email
    end

    private

    def send_invitation_email
      UserMailer::ResponseInviteMailer.invite(
        @user.name,
        @user.email,
        @survey.title,
        invite_link
      ).deliver_now
    end

    def invite_link
      "#{ENV.fetch('APP_WEB_URL', nil)}/surveys/#{@survey.id}/responses/new?user_id=#{@user.id}"
    end
  end
end
