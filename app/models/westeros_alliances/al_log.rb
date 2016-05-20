module WesterosAlliances
  class AlLog < ActiveRecord::Base

    ALLIANCE_CREATION=1
    BEST_BET_TOO_LOW=2

    CODE_CONVERSION = {
      1 => 'Alliance creation', 2 => 'Best bet too low'
    }

    belongs_to :g_game_board

    serialize :alliance_details

    def self.al_log_code_to_string( code )
      CODE_CONVERSION[ code ]
    end

  end
end
