# frozen_string_literal: true

class Survey < ApplicationRecord
  include Discard::Model

  belongs_to :company

  validates :title, presence: true
end

# == Schema Information
#
# Table name: surveys
#
#  id           :bigint           not null, primary key
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
