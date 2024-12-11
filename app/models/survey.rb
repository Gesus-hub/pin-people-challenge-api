# frozen_string_literal: true

class Survey < ApplicationRecord
  include Discard::Model

  belongs_to :company
  has_many :questions, dependent: :destroy
  has_many :responses, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :title, presence: true

  def unanswered_users
    answered_user_ids = responses.pluck(:user_id)
    company.users.where.not(id: answered_user_ids)
  end
end

# == Schema Information
#
# Table name: surveys
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :uuid
#
# Indexes
#
#  index_surveys_on_company_id    (company_id)
#  index_surveys_on_discarded_at  (discarded_at)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
