module WesterosAlliances
  module AlliancesEngine
    module GAlliancesBetEngine

      include Assert

      # The new bet must be at least OLD_BET_MUL time the old one
      OLD_BET_MUL = 2

      # Set a new bet on a house, if the bet already exist, it is replaced
      # TODO : Add logs bet + test logs
      def resolve_bets
        ActiveRecord::Base.transaction do
          AlBet.where( g_game_board_player_id: id ).distinct.pluck( :h_target_house_id ).each do |target_house_id|
            old_bet = al_houses.where( h_house_id: target_house_id ).pluck( :last_bet ).first || 1
            best_bet = al_bets.where( h_target_house_id: target_house_id ).where( 'bet >= ?', old_bet * OLD_BET_MUL ).order( 'bet DESC' ).first
            create_alliance( best_bet.h_house, best_bet.h_target_house, best_bet.bet ) if best_bet
          end
          al_bets.delete_all
        end
      end

      # Set a new bet on a house, if the bet already exist, it is replaced
      def set_bet( master_house, target_house, bet )
        # Only suzerain can make alliances
        assert( self.class, __method__, master_house.suzerain?, "#{master_house.inspect} not suzerain" )
        assert( self.class, __method__, target_house.suzerain?, "#{target_house.inspect} not suzerain" )

        bet_record = al_bets.where( h_house_id: master_house.id, h_target_house_id: target_house.id ).first_or_initialize
        bet_record.bet = bet
        bet_record.save!
      end

      def get_bet( master_house, target_house )
        al_bets.where( h_house_id: master_house.id, h_target_house_id: target_house.id ).pluck( :bet ).first
      end

    end
  end
end