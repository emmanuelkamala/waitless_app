class CreateHospitals < ActiveRecord::Migration[8.0]
  def change
    create_table :hospitals do |t|
      t.string :name
      t.text :address
      t.float :latitude
      t.float :longitude
      t.string :contact_phone
      t.string :email
      t.string :website

      t.timestamps
    end
  end
end
