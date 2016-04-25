require 'active_record'

class AlHouse < ActiveRecord::Base

  belongs_to :g_game_board_player
  belongs_to :h_house

end