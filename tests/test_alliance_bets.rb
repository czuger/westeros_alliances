require 'minitest/autorun'

require_relative '../db/db_connect'
require_relative '../lib/h_house'
require_relative '../lib/al_alliance'
require_relative '../lib/g_game_board_player'
require 'pp'

require_relative '../db/init_houses'

class TestAllianceBets < Minitest::Test

  def setup
    GGameBoardPlayer.destroy_all
    @gbp = GGameBoardPlayer.create!

    @stark = HHouse.find_by_code_name( :stark )
    @lannister = HHouse.find_by_code_name( :lannister )
    @cendermark = HHouse.find_by_code_name( :cendermark )
    @karstark = HHouse.find_by_code_name( :karstark )
    @greyjoy = HHouse.find_by_code_name( :greyjoy )
    @tyrell = HHouse.find_by_code_name( :tyrell )
    @pyk = HHouse.find_by_code_name( :pyk )
    @tarly = HHouse.find_by_code_name( :tarly )
  end

  # def test_alliances_group
  #   pp HHouse.alliances_groups
  # end

  def test_bet_creation_and_replacement
    @gbp.set_bet( @stark, @lannister, 10 )
    assert( 10, @gbp.get_bet( @stark, @lannister ) )

    @gbp.set_bet( @stark, @lannister, 20 )
    assert( 20, @gbp.get_bet( @stark, @lannister ) )

    @gbp.set_bet( @stark, @greyjoy, 30 )
    assert( 20, @gbp.get_bet( @stark, @lannister ) )
    assert( 30, @gbp.get_bet( @stark, @greyjoy ) )

    # If no bet set, get bet should return nil, not raise an error
    refute( @gbp.get_bet( @stark, @stark ) )

    # only master houses can create alliances
    assert_raises RuntimeError do
      @gbp.set_bet( @stark, @tarly, 30 )
    end

  end

end