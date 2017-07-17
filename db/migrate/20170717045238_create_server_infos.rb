class CreateServerInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :server_info do |t|
      t.string :name
      t.string :description
      t.string :location
      t.timestamp :timestamp
    end
  end
end
