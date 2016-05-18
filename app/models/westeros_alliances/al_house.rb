require 'active_record'

# This class contain the house information for a given alliance on a given game board
module WesterosAlliances
  class AlHouse < ActiveRecord::Base

    belongs_to :g_game_board_player
    belongs_to :h_house

  end
end
