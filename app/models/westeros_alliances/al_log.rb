module WesterosAlliances
  class AlLog < ActiveRecord::Base

    ALLIANCE_CREATION=1
    ALLIANCE_BET_RESULT=2

    belongs_to :g_game_board
    belongs_to :h_house
    belongs_to :h_target_house, class_name: 'HHouse'

    serialize :alliance_details
  end
end
