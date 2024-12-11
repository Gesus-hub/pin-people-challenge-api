# frozen_string_literal: true

RSpec.describe Surveys::CreatorService do
  subject { described_class.new(current_user: user, survey_params: params) }

  let(:user) { create(:user, company: create(:company)) }
  let(:params) do
    {
      title: 'Survey Title',
      questions_attributes: [
        {
          content: 'Question 1',
          question_type: 'multiple_choice',
          options_attributes: [
            { value: 'Option 1' },
            { value: 'Option 2' }
          ]
        }
      ]
    }
  end

  context 'when the survey is created successfully' do
    it 'creates a survey with questions and options' do
      expect(subject.call).to be(true)
      expect(Survey.count).to eq(1)
      expect(Survey.last.questions.count).to eq(1)
      expect(Survey.last.questions.first.options.count).to eq(2)
    end
  end

  context 'when the survey creation fails' do
    before { params[:title] = nil }

    it 'does not create a survey and adds errors' do
      expect(subject.call).to be(false)
      expect(Survey.count).to eq(0)
      expect(subject.errors).to include('Title não pode ficar em branco')
    end
  end
end
