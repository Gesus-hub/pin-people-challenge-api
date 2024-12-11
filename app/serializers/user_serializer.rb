# frozen_string_literal: true

class UserSerializer
  def initialize(user)
    @user = user
  end

  def serializable_hash
    hash_for_one_record
  end

  private

  attr_reader :user

  def hash_for_one_record
    {
      name: @user.name,
      email: @user.email,
      role: @user.role,
      metadata: @user.metadata,
      company: CompanySerializer.new(@user.company).serializable_hash
    }
  end
end
