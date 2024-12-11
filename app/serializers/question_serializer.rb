# frozen_string_literal: true

class QuestionSerializer
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
    resource.map { |question| hash_for_one_record(question) }
  end

  def hash_for_one_record(question)
    {
      id: question.id,
      content: question.content,
      question_type: question.question_type,
      created_at: question.created_at,
      updated_at: question.updated_at,
      options: OptionSerializer.new(question.options).serializable_hash,
      responses: ResponseSerializer.new(question.responses).serializable_hash
    }
  end
end
