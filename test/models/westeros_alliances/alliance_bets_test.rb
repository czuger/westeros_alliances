require_relative '../../test_helper'

require 'pp'

class AllianceBetsTest < ActiveSupport::TestCase

  def setup
    GGameBoard.destroy_all

    @gb = GGameBoard.create!

    @stark, @karstark = HHouse.create_house_and_vassals( :stark, :karstark )
    @lannister, @cendermark = HHouse.create_house_and_vassals( :lannister, :cendermark )
    @greyjoy, @pyk = HHouse.create_house_and_vassals( :greyjoy, :pyk )
    @tyrell, @tarly = HHouse.create_house_and_vassals( :tyrell, :tarly )
  end

  # def test_alliances_group
  #   pp HHouse.alliances_groups
  # end

  def test_bet_failure_due_to_low_bet
    @gb.set_bet( @stark, @lannister, 10 )
    @gb.resolve_bets

    @gb.set_bet( @greyjoy, @lannister, 10 )
    @gb.resolve_bets
    # Geryjoy shouldn't be able to steal alliance due to low bet
    assert @gb.allied?( @lannister, @stark )

    @gb.set_bet( @greyjoy, @lannister, 20 )
    @gb.resolve_bets
    # But now it is ok, because the bet is good enough
    assert @gb.allied?( @greyjoy, @lannister )
  end

  def test_bet_resolutions
    @gb.set_bet( @stark, @lannister, 10 )
    @gb.set_bet( @greyjoy, @lannister, 20 )
    @gb.set_bet( @greyjoy, @tyrell, 20 )
    @gb.resolve_bets
    assert @gb.allied?( @greyjoy, @lannister )
    assert @gb.allied?( @greyjoy, @tyrell )
    refute @gb.allied?( @lannister, @stark )

    @gb.set_bet( @stark, @lannister, 40 )
    @gb.resolve_bets
    assert @gb.allied?( @lannister, @stark )
  end

  def test_bet_creation_and_replacement
    @gb.set_bet( @stark, @lannister, 10 )
    assert( 10, @gb.get_bet( @stark, @lannister ) )

    @gb.set_bet( @stark, @lannister, 20 )
    assert( 20, @gb.get_bet( @stark, @lannister ) )

    @gb.set_bet( @stark, @greyjoy, 30 )
    assert( 20, @gb.get_bet( @stark, @lannister ) )
    assert( 30, @gb.get_bet( @stark, @greyjoy ) )

    # If no bet set, get bet should return nil, not raise an error
    refute( @gb.get_bet( @stark, @stark ) )

    # only master houses can create alliances
    assert_raises RuntimeError do
      @gb.set_bet( @stark, @tarly, 30 )
    end
  end

end