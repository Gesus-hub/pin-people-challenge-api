# frozen_string_literal: true

class OptionSerializer
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
    resource.map { |option| hash_for_one_record(option) }
  end

  def hash_for_one_record(option)
    {
      id: option.id,
      value: option.value,
      discarded_at: option.discarded_at,
      created_at: option.created_at,
      updated_at: option.updated_at
    }
  end
end
