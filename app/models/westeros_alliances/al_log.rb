module WesterosAlliances
  class AlLog < ActiveRecord::Base

    ALLIANCE_CREATION=1
    BEST_BET_TOO_LOW=2

    belongs_to :g_game_board

    serialize :alliance_details
  end
end
