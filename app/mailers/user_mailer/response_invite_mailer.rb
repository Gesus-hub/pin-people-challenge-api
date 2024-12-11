# frozen_string_literal: true

module UserMailer
  class ResponseInviteMailer < ApplicationMailer
    def invite(name, email, survey_title, invite_link)
      @name = name
      @survey_title = survey_title
      @invite_link = invite_link

      mail(to: email, subject: "Convite para responder à pesquisa: #{@survey_title}")
    end
  end
end
