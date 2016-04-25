require_relative 'db_connect'

ActiveRecord::Schema.define do

  drop_table :g_game_board_players if ActiveRecord::Base.connection.table_exists? :g_game_board_players
  drop_table :h_houses if ActiveRecord::Base.connection.table_exists? :h_houses
  drop_table :al_alliances if ActiveRecord::Base.connection.table_exists? :al_alliances
  drop_table :al_houses if ActiveRecord::Base.connection.table_exists? :al_houses
  # drop_table :al_neutrals

  create_table :g_game_board_players do |table|
    table.timestamps
  end

  create_table :h_houses do |table|
    table.column :code_name, :string, null: false
    table.references :suzerain, index: true
    table.timestamps
  end
  add_index :h_houses, :code_name, unique: true

  create_table :al_alliances do |table|
    table.references :g_game_board_player, null: false
    table.references :h_house, null: false
    table.references :peer_house, null: false
    table.timestamps
  end
  add_index :al_alliances, [ :g_game_board_player_id, :h_house_id, :peer_house_id ], unique: true, :name => 'al_alliances_unique_index'

  create_table :al_houses do |table|
    table.references :g_game_board_player, null: false
    table.references :h_house, null: false
    table.boolean :minor_alliance_member, default: false
    table.timestamps
  end
  add_index :al_houses, [ :g_game_board_player_id, :h_house_id ], unique: true, :name => 'al_houses_unique_index'


  # create_table :al_neutrals do |table|
  #   table.column :h_house_id, :reference, null: false
  #   table.timestamps
  # end
  # add_index :al_neutrals, :h_house_id, unique: true

end