require 'test_helper'

require 'pp'

class AllianceSetupTest < ActiveSupport::TestCase

  def setup

    GGameBoard.destroy_all

    @gb = GGameBoard.create!

    @stark, @karstark = HHouse.create_house_and_vassals( :stark, :karstark )
    @lannister, @cendermark = HHouse.create_house_and_vassals( :lannister, :cendermark )
    @greyjoy, @pyk = HHouse.create_house_and_vassals( :greyjoy, :pyk )
    @tyrell, @tarly = HHouse.create_house_and_vassals( :tyrell, :tarly )

    # pp HHouse.all.to_a
  end

  # def test_alliances_group
  #   pp HHouse.alliances_groups
  # end

  def test_old_allies_becomes_ennemies
    @gb.create_alliance( @lannister, @tyrell, 1 )
    @gb.set_enemies( @stark, @lannister )
    @gb.create_alliance( @stark, @tyrell, 1 )

    # pp @gb.al_alliances.all.map{ |e| [ e.h_house.code_name, e.h_peer_house.code_name ].join( ', ' ) }.to_a
    # pp @gb.al_enemies.all.map{ |e| [ e.h_house.code_name, e.h_peer_house.code_name ].join( ', ' ) }.to_a
  end

  def test_allies_list
    @gb.create_alliance( @stark, @greyjoy, 1 )
    @gb2 = GGameBoard.create!
    @gb2.set_enemies( @stark, @lannister )
    @gb2.create_alliance( @stark, @greyjoy, 1 )
    assert_includes( @gb.allies( @stark ).pluck( :id ), @greyjoy.id )
    assert_includes( @gb.allies( @stark ).pluck( :id ), @pyk.id )
    refute_includes( @gb.allies( @stark ).pluck( :id ), @stark.id )
    @gb.create_alliance( @stark, @lannister, 1 )
    assert_includes( @gb.allies( @lannister ).pluck( :id ), @greyjoy.id )
    assert_includes( @gb.allies( @lannister ).pluck( :id ), @pyk.id )
    assert_includes( @gb.allies( @lannister ).pluck( :id ), @stark.id )
  end

  def test_alliance_separation_through_game_board
    @gb.create_alliance( @stark, @lannister, 0 )
    assert @gb.allied?( @cendermark, @stark )
    @gb2 = GGameBoard.create!
    refute @gb2.allied?( @cendermark, @stark )
  end

  def test_alliances_stealing
    @gb.create_alliance( @stark, @lannister, 0 )
    @gb.create_alliance( @stark, @greyjoy, 0 )
    @gb.create_alliance( @tyrell, @greyjoy, 0 )
    assert @gb.allied?( @cendermark, @stark )
    refute @gb.allied?( @pyk, @stark )
    refute @gb.allied?( @pyk, @cendermark )
    assert @gb.allied?( @pyk, @tarly )
  end

  def test_ennemies_with_alliances_stealing
    @gb.create_alliance( @stark, @lannister, 0 )
    @gb.create_alliance( @tyrell, @greyjoy, 0 )
    @gb.set_enemies( @stark, @tyrell )
    assert @gb.enemies?( @stark, @greyjoy )
    assert @gb.enemies?( @stark, @greyjoy )
    @gb.create_alliance( @stark, @greyjoy, 0 )
    refute @gb.enemies?( @stark, @greyjoy )
    assert @gb.enemies?( @tyrell, @greyjoy )
  end

  def test_advanced_alliances
    @gb.create_alliance( @stark, @lannister, 0 )
    @gb.create_alliance( @stark, @greyjoy, 0 )
    assert_raises {
      @gb.create_alliance( @lannister, @tyrell, 0 )
    }
    assert @gb.allied?( @cendermark, @stark )
    assert @gb.allied?( @pyk, @cendermark )
    assert @gb.allied?( @pyk, @stark )
    refute @gb.allied?( @pyk, @tarly )
  end

  def test_basic_alliances
    assert_raises {
      @gb.create_alliance( @stark, @cendermark, 0 )
    }
    assert_raises {
      @gb.create_alliance( @cendermark, @stark, 0 )
    }
    @gb.create_alliance( @stark, @lannister, 0 )

    # pp WesterosAlliances::AlLog.all

    assert @gb.allied?( @stark, @cendermark )
    assert @gb.allied?( @cendermark, @stark )
    assert @gb.allied?( @karstark, @cendermark )
    assert_equal(
      [ @lannister, @cendermark, @karstark ].map{ |e| e.id }.sort, @gb.allies( @stark ).map{ |e| e.id }.sort )

    refute( @gb.minor_alliance_member?( @stark ) )
    refute( @gb.minor_alliance_member?( @tarly ) )

    assert( @gb.minor_alliance_member?( @cendermark ) )
  end

  def test_last_bet_set_after_alliance_creation
    @gb.create_alliance( @stark, @lannister, 20 )
    assert 20, @gb.al_houses.where( h_house_id: @lannister.id ).first.last_bet
    @gb.create_alliance( @greyjoy, @lannister, 40 )
    assert 40, @gb.al_houses.where( h_house_id: @lannister.id ).first.last_bet
  end

  def test_vassal_suzerain
    assert @karstark.vassal?
    assert @stark.suzerain?
    refute @stark.vassal?
    refute @karstark.suzerain?
  end

  def test_alliances_hash
    @gb.create_alliance( @stark, @lannister, 1 )
    @gb.set_enemies( @stark, @greyjoy )
    result_hash = @gb.alliances_hash( @stark )
    assert_equal( 4, result_hash[ :allies ].count )
    assert_equal( 2, result_hash[ :enemies ].count )
    assert_equal( 2, result_hash[ :neutrals ].count )
  end


end