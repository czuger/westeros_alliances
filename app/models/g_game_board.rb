class GGameBoard < ActiveRecord::Base

  has_many :g_game_board_players, dependent: :destroy
  has_many :westeros_alliances_al_logs, :class_name => 'WesterosAlliances::AlLog', dependent: :destroy

end
