# frozen_string_literal: true

class SurveySerializer
  def initialize(resource)
    @resource = resource
  end

  def serializable_hash
    return if resource.blank?
    return hash_for_collection if resource.is_a?(Enumerable)

    hash_for_one_record(resource)
  end

  private

  attr_reader :resource

  def hash_for_collection
    resource.map { |survey| hash_for_one_record(survey) }
  end

  def hash_for_one_record(survey)
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
end
