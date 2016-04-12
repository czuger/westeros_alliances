require_relative 'db/db_connect'
require_relative 'lib/h_house'
require_relative 'lib/al_alliance'
require 'pp'

require 'minitest/autorun'

class TestAllianceSetup < Minitest::Test

  def setup
    HHouse.destroy_all
    @stark = HHouse.create_house( :stark )
    @karstark = @stark.create_vassal( :karstark )
    @lannister = HHouse.create_house( :lannister )
    @cendermark = @lannister.create_vassal( :cendermark )
    @greyjoy = HHouse.create_house( :greyjoy )
    @pyk = @greyjoy.create_vassal( :pyk )
    @tyrell = HHouse.create_house( :tyrell )
    @tarly = @tyrell.create_vassal( :tarly )
  end

  # def test_alliances_group
  #   pp HHouse.alliances_groups
  # end

  def test_alliances_stealing
    @stark.create_alliance( @lannister )
    @stark.create_alliance( @greyjoy )
    @tyrell.create_alliance( @greyjoy )
    assert @cendermark.allied?( @stark )
    refute @pyk.allied?( @cendermark )
    refute @pyk.allied?( @stark )
    assert @pyk.allied?( @tarly )
  end

  def test_advanced_alliances
    @stark.create_alliance( @lannister )
    @stark.create_alliance( @greyjoy )
    assert_raises {
      @lannister.create_alliance( @tyrell )
    }
    assert @cendermark.allied?( @stark )
    assert @pyk.allied?( @cendermark )
    assert @pyk.allied?( @stark )
    refute @pyk.allied?( @tarly )
  end

  def test_basic_alliances
    assert_raises {
      @stark.create_alliance( @cendermark )
    }
    assert_raises {
      @cendermark.create_alliance( @stark )
    }
    @stark.create_alliance( @lannister )
    assert @stark.allied?( @cendermark )
    assert @cendermark.allied?( @stark )
    assert @karstark.allied?( @cendermark )
    assert_equal(
      [ @lannister, @cendermark, @karstark ].sort{ |x, y| x.code_name <=> y.code_name },
      @stark.allies.sort{ |x, y| x.code_name <=> y.code_name }
    )
  end

  def test_vassal_suzerain
    assert @karstark.vassal?
    assert @stark.suzerain?
    refute @stark.vassal?
    refute @karstark.suzerain?
    assert @stark.allied?( @karstark )
    refute @stark.allied?( @stark )
    refute @stark.allied?( @cendermark )
  end

end