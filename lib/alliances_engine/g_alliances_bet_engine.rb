require_relative '../assert'
require_relative '../al_bet'

module GAlliancesBetEngine

  include Assert

  # The new bet must be at least OLD_BET_MUL time the old one
  OLD_BET_MUL = 2

  # TODO : Create a log that keep all alliances movement, create a log table for alliances issues only (don't mix all logs)
  #  - Alliances créations
  #  - Alliances changes
  #  - Alliances stealings
  #  - Alliances rejected
  #  All logs are stored in table as tuples ( game_board, house_asking, house_target, status, bet, min_bet )
  #  Status is an integer

  # TODO : pluginize with : http://guides.rubyonrails.org/plugins.html

  # Set a new bet on a house, if the bet already exist, it is replaced
  def resolve_bets
    old_bet = 0 # In the future, this wille be the old bet kept
    AlBet.where( g_game_board_player_id: id ).distinct.pluck( :h_target_house_id ).each do |target_house_id|
      best_bet = AlBet.where( g_game_board_player_id: id, h_target_house_id: target_house_id )
        .where( 'bet > ?', old_bet * OLD_BET_MUL ).order( 'bet DESC' ).first
      create_alliance( best_bet.master_house, best_bet.target_house, best_bet.bet )
    end
  end

  # Set a new bet on a house, if the bet already exist, it is replaced
  def set_bet( master_house, target_house, bet )
    # Only suzerain can make alliances
    assert( self.class, __method__, master_house.suzerain?, "#{master_house.inspect} not suzerain" )
    assert( self.class, __method__, target_house.suzerain?, "#{target_house.inspect} not suzerain" )

    bet_record = AlBet.where( g_game_board_player_id: id, h_master_house_id: master_house.id ).find_or_initialize_by( h_target_house_id: target_house.id )
    bet_record.bet = bet
    bet_record.save!
  end

  def get_bet( master_house, target_house )
    AlBet.where( g_game_board_player_id: id, h_master_house_id: master_house.id, h_target_house_id: target_house.id ).pluck( :bet ).first
  end

end