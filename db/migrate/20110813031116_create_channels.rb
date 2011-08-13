class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.text :description
      t.integer :owner_id
      t.timestamps
    end
    
    add_index :channels, :name
    add_index :channels, :owner_id
  end
end
