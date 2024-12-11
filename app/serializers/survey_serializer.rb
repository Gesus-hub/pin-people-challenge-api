# frozen_string_literal: true

class SurveySerializer
  def initialize(survey)
    @survey = survey
  end

  def serializable_hash
    hash_for_one_record
  end

  private

  attr_reader :survey

  # rubocop:disable Metrics/AbcSize
  def hash_for_one_record
    {
      id: survey.id,
      title: survey.title,
      created_at: survey.created_at,
      updated_at: survey.updated_at,
      questions: QuestionSerializer.new(survey.questions).serializable_hash,
      options: OptionSerializer.new(survey.options).serializable_hash,
      company: CompanySerializer.new(survey.company).serializable_hash
    }
  end
  # rubocop:enable Metrics/AbcSize
end
