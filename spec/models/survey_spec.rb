# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Survey do
  describe 'associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:questions).dependent(:destroy) }
    it { is_expected.to accept_nested_attributes_for(:questions).allow_destroy(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'nested attributes' do
    let(:survey) do
      described_class.new(
        title: 'Customer Feedback',
        company: create(:company),
        questions_attributes: [
          {
            content: 'How satisfied are you?',
            question_type: 'scale',
            options_attributes: [
              { value: 'Very Satisfied' },
              { value: 'Satisfied' }
            ]
          },
          {
            content: 'Would you recommend us?',
            question_type: 'boolean'
          }
        ]
      )
    end

    it 'creates questions and options using nested attributes' do
      expect { survey.save }.to change(Question, :count).by(2)
      expect(Option.count).to eq(2)
    end

    it 'destroys nested questions when allow_destroy is true' do
      survey.save
      question_id = survey.questions.first.id
      survey.update(questions_attributes: [{ id: question_id, _destroy: true }])

      expect(Question).not_to exist(question_id)
    end
  end
end
