class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.references :hospital, null: false, foreign_key: true
      t.datetime :appointment_date
      t.string :status
      t.text :notes

      t.timestamps
    end
  end
end
