# frozen_string_literal: true

class Option < ApplicationRecord
  include Discard::Model

  belongs_to :question

  validates :value, presence: true
end

# == Schema Information
#
# Table name: options
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  value        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  question_id  :uuid             not null
#
# Indexes
#
#  index_options_on_discarded_at  (discarded_at)
#  index_options_on_question_id   (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
