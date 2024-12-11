# frozen_string_literal: true

class UserSerializer
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
    resource.map { |user| hash_for_one_record(user) }
  end

  def hash_for_one_record(user)
    {
      id: user.id,
      name: user.name,
      role: user.role,
      email: user.email,
      metadata: user.metadata,
      company: CompanySerializer.new(user.company).serializable_hash
    }
  end
end
