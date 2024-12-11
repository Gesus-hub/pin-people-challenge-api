class CreateSurveys < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    create_table :surveys do |t|
      t.string :title, null: false
      t.datetime :discarded_at,          index: true

      t.references :company, type: :uuid, foreign_key: true, index: { algorithm: :concurrently }

      t.timestamps
    end
  end
end
