# frozen_string_literal: true

class Question < ApplicationRecord
  include Discard::Model

  belongs_to :survey
  has_many :options, dependent: :destroy

  validates :content, presence: true
  validates :question_type, presence: true

  enum :question_type, { open_text: 0, boolean: 1, scale: 2, multiple_choice: 3 }

  # accepts_nested_attributes_for :options, allow_destroy: true
end

# == Schema Information
#
# Table name: questions
#
#  id            :uuid             not null, primary key
#  content       :string           not null
#  discarded_at  :datetime
#  question_type :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  survey_id     :uuid
#
# Indexes
#
#  index_questions_on_discarded_at  (discarded_at)
#  index_questions_on_survey_id     (survey_id)
#
# Foreign Keys
#
#  fk_rails_...  (survey_id => surveys.id)
#
