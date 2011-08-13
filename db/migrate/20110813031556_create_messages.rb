class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :channel_id
      t.text :content
      t.string :name
      t.integer :user_id

      t.timestamps
    end
    
    add_index :messages, :channel_id
    add_index :messages, :user_id    
  end
end
