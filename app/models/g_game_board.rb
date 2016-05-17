class GGameBoard < ActiveRecord::Base

  has_many :g_game_board_players, dependent: :destroy

end
