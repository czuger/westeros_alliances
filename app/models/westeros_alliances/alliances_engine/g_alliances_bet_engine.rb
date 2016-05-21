module WesterosAlliances
  module AlliancesEngine
    module GAlliancesBetEngine

      include Assert

      # The new bet must be at least OLD_BET_MUL time the old one
      OLD_BET_MUL = 2

      # Set a new bet on a house, if the bet already exist, it is replaced
      def resolve_bets
        ActiveRecord::Base.transaction do
          AlBet.where( g_game_board_id: id ).distinct.pluck( :h_target_house_id ).each do |target_house_id|

            old_bet = al_houses.where( h_house_id: target_house_id ).pluck( :last_bet ).first || 1
            min_bet = min_bet_value( old_bet )

            best_bet = al_bets.where( h_target_house_id: target_house_id ).order( 'bet DESC' ).first
            second_best_bet = al_bets.where( h_target_house_id: target_house_id ).order( 'bet DESC' ).second
            target_house = HHouse.find_by( id: target_house_id )

            if best_bet && best_bet.bet > 0 # We don't take care 0 bets (process them as no bat at all)

              if best_bet.bet < min_bet

                westeros_alliances_al_logs.create!(
                  g_game_board_id: id, log_code: WesterosAlliances::AlLog::BEST_BET_TOO_LOW,
                  alliance_details: { best_bet: best_bet.bet, min_bet: min_bet, target_house: target_house.code_name,
                                      bet_detail: get_bet_details_as_hash(target_house)}, turn: turn)

              elsif second_best_bet && best_bet.bet == second_best_bet.bet

                westeros_alliances_al_logs.create!(
                  g_game_board_id: id, log_code: WesterosAlliances::AlLog::BEST_BET_EQUALITY,
                  alliance_details: { min_bet: min_bet, target_house: target_house.code_name,
                                      bet_detail: get_bet_details_as_hash(target_house)}, turn: turn)
              else

                  create_alliance( best_bet.h_house, best_bet.h_target_house, best_bet.bet )
                  westeros_alliances_al_logs.create!(
                    g_game_board_id: id, log_code: WesterosAlliances::AlLog::ALLIANCE_CREATION,
                    alliance_details: { best_bet: best_bet.bet, min_bet: min_bet, winning_house: best_bet.h_house.code_name,
                    target_house: target_house.code_name, bet_detail: get_bet_details_as_hash( target_house ) }, turn: turn )

              end
            end
          end
          al_bets.delete_all
        end
      end

      def min_bet_value( old_bet )
        old_bet * OLD_BET_MUL
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

      def get_bet_details_as_hash( target_house )
        result = []
        al_bets.includes( :h_house ).where( h_target_house_id: target_house.id ).order( :bet ).each do |bet|
          result << { asking_house: bet.h_house.code_name, bet: bet.bet }
        end
        result
      end

    end
  end
end