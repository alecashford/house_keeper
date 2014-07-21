class CreateExpenditures < ActiveRecord::Migration
  def change
    create_table :expenditures do |t|
      t.integer :user_id
      t.integer :house_id
      t.integer :amount
      t.boolean :active, :default => true
      t.text :note

      t.timestamps
    end
  end
end
