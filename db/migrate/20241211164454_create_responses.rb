class CreateResponses < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    create_table :responses, id: :uuid do |t|
      t.references :survey, null: false, type: :uuid
      t.references :question, null: false, type: :uuid
      t.references :user, null: false, type: :uuid
      t.string :value, null: false
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :responses, :discarded_at, algorithm: :concurrently
    add_index :responses, [:survey_id, :user_id], unique: true, algorithm: :concurrently
  end
end
