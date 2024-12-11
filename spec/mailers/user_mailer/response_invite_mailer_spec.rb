# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer::ResponseInviteMailer do
  let(:user) { create(:user, :with_company) }
  let(:survey) { create(:survey, company: user.company) }
  let(:invite_link) { "http://example.com/surveys/#{survey.id}/responses/new?user_id=#{user.id}" }

  describe '#invite' do
    let(:mail) { described_class.invite(user.name, user.email, survey.title, invite_link) }

    it 'renders the headers' do
      expect(mail.subject).to eq("Convite para responder à pesquisa: #{survey.title}")
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include("<strong>#{user.name}</strong>")
      expect(mail.body.encoded).to include(
        %(Você foi convidado a responder à pesquisa "<strong>#{survey.title}</strong>".)
      )
      expect(mail.body.encoded).to include(invite_link)
    end
  end
end
