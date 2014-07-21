class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.string :house_number
      t.string :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.string :house_code

      t.timestamps
    end
  end
end
