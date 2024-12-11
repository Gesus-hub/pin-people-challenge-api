# frozen_string_literal: true

class CompanySerializer
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
    resource.map { |company| hash_for_one_record(company) }
  end

  def hash_for_one_record(company)
    {
      id: company.id,
      name: company.name,
      trade_name: company.trade_name,
      email: company.email,
      website_facebook: company.website_facebook,
      business_description: company.business_description,
      status: company.status,
      metadata: company.metadata,
      discarded_at: company.discarded_at,
      created_at: company.created_at,
      updated_at: company.updated_at,
      users: UserSerializer.new(company.users).serializable_hash
    }
  end
end
