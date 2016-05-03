require_relative 'db_connect'

# TODO : finalize adding foreign keys

ActiveRecord::Schema.define do

  drop_table :al_alliances if ActiveRecord::Base.connection.table_exists? :al_alliances
  drop_table :al_houses if ActiveRecord::Base.connection.table_exists? :al_houses
  drop_table :al_bets if ActiveRecord::Base.connection.table_exists? :al_bets
  drop_table :al_ennemies if ActiveRecord::Base.connection.table_exists? :al_ennemies
  drop_table :g_game_board_players if ActiveRecord::Base.connection.table_exists? :g_game_board_players
  drop_table :h_houses if ActiveRecord::Base.connection.table_exists? :h_houses

  create_table :g_game_board_players do |table|
    table.timestamps
  end

  create_table :h_houses do |table|
    table.column :code_name, :string, null: false
    table.references :h_suzerain_house, index: true
    table.timestamps
  end
  add_index :h_houses, :code_name, unique: true
  add_foreign_key :h_houses, :h_houses, column: :h_suzerain_house_id

  create_table :al_alliances do |table|
    table.references :g_game_board_player, null: false, foreign_key: true
    table.references :h_house, null: false, foreign_key: true
    table.references :h_peer_house, null: false
    table.timestamps
  end
  add_index :al_alliances, [ :g_game_board_player_id, :h_house_id, :h_peer_house_id ], unique: true, :name => 'al_alliances_unique_index'
  add_foreign_key :al_alliances, :h_houses, column: :h_peer_house_id

  create_table :al_houses do |table|
    table.references :g_game_board_player, null: false, foreign_key: true
    table.references :h_house, null: false, foreign_key: true
    table.boolean :minor_alliance_member, default: false
    table.integer :last_bet, null: false
    table.timestamps
  end
  add_index :al_houses, [ :g_game_board_player_id, :h_house_id ], unique: true, :name => 'al_houses_unique_index'

  create_table :al_bets do |table|
    table.references :g_game_board_player, null: false, foreign_key: true
    table.references :h_house, null: false, foreign_key: true
    table.references :h_target_house, null: false
    table.integer :bet, null: false, default: 0
    table.timestamps
  end
  add_index :al_bets, [ :g_game_board_player_id, :h_house_id, :h_target_house_id  ], unique: true, :name => 'al_bets_unique_index'
  add_foreign_key :al_bets, :h_houses, column: :h_target_house_id

  create_table :al_ennemies do |table|
    table.references :g_game_board_player, null: false, foreign_key: true
    table.references :h_house, null: false, foreign_key: true
    table.references :h_ennemy_house, null: false
    table.timestamps
  end
  add_index :al_ennemies, [ :h_house_id, :h_ennemy_house_id ], unique: true, :name => 'al_ennemies_unique_index'
  add_foreign_key :al_ennemies, :h_houses, column: :h_ennemy_house_id

end