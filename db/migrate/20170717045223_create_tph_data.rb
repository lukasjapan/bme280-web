class CreateTphData < ActiveRecord::Migration[5.1]
  def change
    create_table :tph_data, id: false do |t|
      t.timestamp :timestamp
      t.float :t
      t.float :p
      t.float :h
    end
    
    add_index :tph_data, :timestamp
  end
end
