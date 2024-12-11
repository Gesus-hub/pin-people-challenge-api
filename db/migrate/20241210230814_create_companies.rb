class CreateCompanies < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    create_table :companies, id: :uuid do |t|
      t.string   :name,                    null: false
      t.string   :trade_name,              null: false
      t.string   :email,                   null: false
      t.string   :website_facebook,        null: false
      t.string   :business_description,    null: false
      t.integer  :status,                  default: 1
      t.jsonb    :metadata,                index: { using: :gin, algorithm: :concurrently }, default: {}
      t.datetime :discarded_at,            index: true

      t.timestamps
    end
  end
end
