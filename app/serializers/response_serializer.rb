# frozen_string_literal: true

class ResponseSerializer
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
    resource.map { |response| hash_for_one_record(response) }
  end

  def hash_for_one_record(response)
    {
      id: response.id,
      value: response.value,
      discarded_at: response.discarded_at,
      created_at: response.created_at,
      updated_at: response.updated_at,
      question: QuestionSerializer.new(response.question).serializable_hash,
      user: UserSerializer.new(response.user).serializable_hash
    }
  end
end
