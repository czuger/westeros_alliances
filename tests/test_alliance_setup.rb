require 'minitest/autorun'

require_relative '../db/db_connect'
require_relative '../lib/h_house'
require_relative '../lib/al_alliance'
require_relative '../lib/g_game_board_player'
require 'pp'

require_relative '../db/init_houses'

class TestAllianceSetup < Minitest::Test

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

  def test_alliances_stealing
    @gbp.create_alliance( @stark, @lannister )
    @gbp.create_alliance( @stark, @greyjoy )
    @gbp.create_alliance( @tyrell, @greyjoy )
    assert @gbp.allied?( @cendermark, @stark )
    refute @gbp.allied?( @pyk, @stark )
    refute @gbp.allied?( @pyk, @cendermark )
    assert @gbp.allied?( @pyk, @tarly )
  end

  def test_advanced_alliances
    @gbp.create_alliance( @stark, @lannister )
    @gbp.create_alliance( @stark, @greyjoy )
    assert_raises {
      @gbp.create_alliance( @lannister, @tyrell )
    }
    assert @gbp.allied?( @cendermark, @stark )
    assert @gbp.allied?( @pyk, @cendermark )
    assert @gbp.allied?( @pyk, @stark )
    refute @gbp.allied?( @pyk, @tarly )
  end

  def test_basic_alliances
    assert_raises {
      @gbp.create_alliance( @stark, @cendermark )
    }
    assert_raises {
      @gbp.create_alliance( @cendermark, @stark )
    }
    @gbp.create_alliance( @stark, @lannister )
    assert @gbp.allied?( @stark, @cendermark )
    assert @gbp.allied?( @cendermark, @stark )
    assert @gbp.allied?( @karstark, @cendermark )
    assert_equal(
      [ @lannister, @cendermark, @karstark ].sort{ |x, y| x.code_name <=> y.code_name },
      @gbp.allies( @stark ).sort{ |x, y| x.code_name <=> y.code_name }
    )

    refute( @gbp.minor_alliance_member?( @stark ) )
    refute( @gbp.minor_alliance_member?( @tarly ) )

    assert( @gbp.minor_alliance_member?( @cendermark ) )
  end

  def test_vassal_suzerain
    assert @karstark.vassal?
    assert @stark.suzerain?
    refute @stark.vassal?
    refute @karstark.suzerain?
  end

end