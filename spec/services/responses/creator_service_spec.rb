# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Responses::CreatorService, type: :service do
  subject do
    described_class.new(
      current_user: user,
      survey: survey,
      response_params: response_params
    )
  end

  let(:user) { create(:user, :with_company) }
  let(:survey) { create(:survey) }
  let(:question) { create(:question, survey: survey) }
  let(:response_params) do
    {
      question_id: question.id,
      value: 'Satisfied'
    }
  end

  describe '#call' do
    context 'with valid parameters' do
      it 'creates a response and returns true' do
        expect(subject.call).to be(true)

        response = Response.last
        expect(response).to be_present
        expect(response.user).to eq(user)
        expect(response.survey).to eq(survey)
        expect(response.question).to eq(question)
        expect(response.value).to eq('Satisfied')
      end
    end

    context 'with invalid parameters' do
      let(:response_params) { { question_id: nil, value: nil } }

      it 'does not create a response and returns false' do
        expect(subject.call).to be(false)
        expect(subject.errors).to include(
          'Question deve existir',
          'Valor não pode ficar em branco'
        )
      end
    end
  end
end
