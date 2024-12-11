# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question do
  describe 'associations' do
    it { is_expected.to belong_to(:survey) }
    it { is_expected.to have_many(:options).dependent(:destroy) }
    it { is_expected.to accept_nested_attributes_for(:options).allow_destroy(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:question_type) }
    it { is_expected.to define_enum_for(:question_type).with_values(%w[open_text boolean scale multiple_choice]) }
  end

  describe 'nested attributes' do
    let(:question) do
      described_class.new(
        content: 'How satisfied are you?',
        question_type: 'scale',
        survey: create(:survey),
        options_attributes: [
          { value: 'Very Satisfied' },
          { value: 'Satisfied' }
        ]
      )
    end

    it 'creates options using nested attributes' do
      puts "Option count before save: #{Option.count}"
      expect { question.save }.to change(Option, :count).by(26)
      puts "Option count after save: #{Option.count}"
    end
  end
end
