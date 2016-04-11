require_relative 'db_connect'

ActiveRecord::Schema.define do

  drop_table :h_houses if ActiveRecord::Base.connection.table_exists? :h_houses
  drop_table :al_alliances if ActiveRecord::Base.connection.table_exists? :al_alliances
  # drop_table :al_neutrals

  create_table :h_houses do |table|
    table.column :code_name, :string, null: false
    table.references :suzerain, index: true
    table.references :alliance_master, index: true
    table.timestamps
  end
  add_index :h_houses, :code_name, unique: true

  create_table :al_alliances do |table|
    table.references :h_house, null: false
    table.references :peer_house, null: false
    table.timestamps
  end
  add_index :al_alliances, [ :h_house_id, :peer_house_id ], unique: true

  # create_table :al_neutrals do |table|
  #   table.column :h_house_id, :reference, null: false
  #   table.timestamps
  # end
  # add_index :al_neutrals, :h_house_id, unique: true

end