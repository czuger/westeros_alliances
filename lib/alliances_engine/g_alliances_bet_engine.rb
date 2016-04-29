require_relative '../assert'
require_relative '../al_bet'

module GAlliancesBetEngine

  include Assert

  # TODO : add a method to resolve bets

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