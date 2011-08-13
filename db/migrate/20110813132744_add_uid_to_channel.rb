class AddUidToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :uid, :string
    
    add_index :channels, :uid
  end
end
