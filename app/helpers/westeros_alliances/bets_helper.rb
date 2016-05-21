require 'pp'

module WesterosAlliances
  module BetsHelper

    def current_bet( al_house )
      bet = @bets[ @asking_house.id ] ? @bets[ @asking_house.id ][ al_house.h_house_id ] : 0
      bet && bet > 0 ? bet : nil
    end

  end
end
