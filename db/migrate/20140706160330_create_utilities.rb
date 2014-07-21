class CreateUtilities < ActiveRecord::Migration
  def change
    create_table :utilities do |t|
      t.integer :house_id
      t.string :utility_type
      t.string :provider
      t.integer :amount
      t.boolean :paid, :default => false
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end