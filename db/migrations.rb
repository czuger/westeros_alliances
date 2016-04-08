require_relative 'db_connect'

ActiveRecord::Schema.define do

  create_table :houses do |table|
    table.column :code_name, :string
    table.column :suzerain_id, :reference
    table.timestamps
  end
  add_index :houses, :code_name, unique: true

  create_table :alliances do |table|
    table.column :house_id, :reference
    table.column :ally_id, :reference
    table.timestamps
  end
  add_index :alliances, [ :house_id, :ally_id ], unique: true

end