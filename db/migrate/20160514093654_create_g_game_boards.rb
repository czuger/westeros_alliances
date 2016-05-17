class CreateGGameBoards < ActiveRecord::Migration
  def change
    create_table :g_game_boards do |t|
      t.integer :turn

      t.timestamps null: false
    end
    add_column :g_game_board_players, :g_game_board_id, :integer, foreign_key: true, index: true
  end
end
