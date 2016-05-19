class RootModels < ActiveRecord::Migration
  def change

    create_table :g_game_boards do |t|
      t.integer :turn, null: false, default: 1
      t.timestamps null: false
    end

    create_table :g_game_board_players do |table|
      table.references :g_game_board, foreign_key: true, index: true, null: false
      table.timestamps null: false
    end

    create_table :h_houses do |table|
      table.column :code_name, :string, null: false
      table.references :h_suzerain_house, index: true
      table.timestamps null: false
    end
    add_index :h_houses, :code_name, unique: true
    add_foreign_key :h_houses, :h_houses, column: :h_suzerain_house_id

    create_table :westeros_alliances_al_relationships do |table|
      table.references :g_game_board, null: false, foreign_key: true
      table.references :h_house, null: false, foreign_key: true
      table.references :h_peer_house, null: false
      table.string :type, index: true, null: false
      table.timestamps null: false
    end
    add_index :westeros_alliances_al_relationships, [ :g_game_board_id, :h_house_id, :h_peer_house_id ], unique: true, :name => 'al_relationships_unique_index'
    add_foreign_key :westeros_alliances_al_relationships, :h_houses, column: :h_peer_house_id

    create_table :westeros_alliances_al_houses do |table|
      table.references :g_game_board, null: false, foreign_key: true
      table.references :h_house, null: false, foreign_key: true
      table.boolean :minor_alliance_member, default: true
      table.integer :last_bet, null: false, default: 0
      table.timestamps null: false
    end
    add_index :westeros_alliances_al_houses, [ :g_game_board_id, :h_house_id ], unique: true, :name => 'al_houses_unique_index'

    create_table :westeros_alliances_al_bets do |table|
      table.references :g_game_board, null: false, foreign_key: true
      table.references :h_house, null: false, foreign_key: true
      table.references :h_target_house, null: false
      table.integer :bet, null: false, default: 0
      table.timestamps null: false
    end
    add_index :westeros_alliances_al_bets, [ :g_game_board_id, :h_house_id, :h_target_house_id  ], unique: true, :name => 'al_bets_unique_index'
    add_foreign_key :westeros_alliances_al_bets, :h_houses, column: :h_target_house_id

    # create_table :al_enemies do |table|
    #   table.references :g_game_board_player, null: false, foreign_key: true
    #   table.references :h_house, null: false, foreign_key: true
    #   table.references :h_enemy_house, null: false
    #   table.timestamps
    # end
    # add_index :al_enemies, [ :h_house_id, :h_enemy_house_id ], unique: true, :name => 'al_enemies_unique_index'
    # add_foreign_key :al_enemies, :h_houses, column: :h_enemy_house_id

  end
end
