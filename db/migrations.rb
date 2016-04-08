require_relative 'db_connect'

ActiveRecord::Schema.define do

  drop_table :h_houses
  drop_table :al_alliances
  drop_table :al_neutrals

  create_table :h_houses do |table|
    table.column :code_name, :string, null: false
    table.column :suzerain_id, :reference
    table.timestamps
  end
  add_index :h_houses, :code_name, unique: true

  create_table :al_alliances do |table|
    table.column :master_id, :reference, null: false
    table.column :h_house_id, :reference, null: false
    table.timestamps
  end
  add_index :al_alliances, [ :master_id, :h_house_id ], unique: true
  add_index :al_alliances, :h_house_id

  # create_table :al_neutrals do |table|
  #   table.column :h_house_id, :reference, null: false
  #   table.timestamps
  # end
  # add_index :al_neutrals, :h_house_id, unique: true

end