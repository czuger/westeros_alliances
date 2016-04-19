require_relative 'db/db_connect'
require_relative 'lib/h_house'
require_relative 'lib/al_alliance'
require_relative 'lib/g_game_board_player'
require 'pp'

require 'minitest/autorun'

class TestAllianceSetup < Minitest::Test

  def setup
    GGameBoardPlayer.destroy_all
    @gbp = GGameBoardPlayer.create!

    @stark = HHouse.find_by_code_name( :stark )
    @lannister = HHouse.find_by_code_name( :lannister )
    @cendermark = HHouse.find_by_code_name( :cendermark )
    @karstark = HHouse.find_by_code_name( :karstark )
    @greyjoy= HHouse.find_by_code_name( :greyjoy)
    @tyrell= HHouse.find_by_code_name( :tyrell)
    @pyk= HHouse.find_by_code_name( :pyk)
  end

  # def test_alliances_group
  #   pp HHouse.alliances_groups
  # end

  def test_alliances_stealing
    @gbp.create_alliance( @stark, @lannister )
    @gbp.create_alliance( @stark, @greyjoy )
    @gbp.create_alliance( @tyrell, @greyjoy )
    assert @cendermark.allied?( @gbp, @stark )
    refute @pyk.allied?( @gbp, @cendermark )
    refute @pyk.allied?( @gbp, @stark )
    assert @pyk.allied?( @gbp, @tarly )
  end

  def test_advanced_alliances
    @gbp.create_alliance( @stark, @lannister )
    @gbp.create_alliance( @stark, @greyjoy )
    assert_raises {
      @gbp.create_alliance( @lannister, @tyrell )
    }
    assert @cendermark.allied?( @gbp, @stark )
    assert @pyk.allied?( @gbp, @cendermark )
    assert @pyk.allied?( @gbp, @stark )
    refute @pyk.allied?( @gbp, @tarly )
  end

  def test_basic_alliances
    assert_raises {
      @gbp.create_alliance( @stark, @cendermark )
    }
    assert_raises {
      @gbp.create_alliance( @cendermark, @stark )
    }
    @gbp.create_alliance( @stark, @lannister )
    assert @stark.allied?( @gbp, @cendermark )
    assert @cendermark.allied?( @gbp, @stark )
    assert @karstark.allied?( @gbp, @cendermark )
    assert_equal(
      [ @lannister, @cendermark, @karstark ].sort{ |x, y| x.code_name <=> y.code_name },
      @stark.allies( @gbp ).sort{ |x, y| x.code_name <=> y.code_name }
    )
  end

  def test_vassal_suzerain
    assert @karstark.vassal?
    assert @stark.suzerain?
    refute @stark.vassal?
    refute @karstark.suzerain?
  end

end