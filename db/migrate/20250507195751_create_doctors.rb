class CreateDoctors < ActiveRecord::Migration[8.0]
  def change
    create_table :doctors do |t|
      t.references :user, null: false, foreign_key: true
      t.references :specialty, null: false, foreign_key: true
      t.references :hospital, null: false, foreign_key: true
      t.text :bio
      t.string :license_number

      t.timestamps
    end
  end
end
