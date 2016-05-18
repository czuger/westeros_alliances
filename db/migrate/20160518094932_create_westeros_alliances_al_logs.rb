class CreateWesterosAlliancesAlLogs < ActiveRecord::Migration
  def change
    create_table :westeros_alliances_al_logs do |t|
      t.references :g_game_board, index: true, foreign_key: true, null: false
      t.references :h_house, index: true, foreign_key: true, null: false
      t.references :h_target_house, index: true, foreign_key: true, null: false
      t.integer :log_code, null: false
      t.string :alliance_details, null: false

      t.timestamps null: false
    end
  end
end
