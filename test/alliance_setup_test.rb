require_relative 'test_helper'

require_relative '../lib/h_house'
require_relative '../lib/al_alliance'
require_relative '../lib/g_game_board_player'

require 'pp'

class AllianceSetupTest < ActiveSupport::TestCase

  def setup
    GGameBoardPlayer.destroy_all
    @gbp = GGameBoardPlayer.create!

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
    @gbp.create_alliance( @lannister, @tyrell, 1 )
    @gbp.set_enemies( @stark, @lannister )
    @gbp.create_alliance( @stark, @tyrell, 1 )

    # pp @gbp.al_alliances.all.map{ |e| [ e.h_house.code_name, e.h_peer_house.code_name ].join( ', ' ) }.to_a
    # pp @gbp.al_enemies.all.map{ |e| [ e.h_house.code_name, e.h_peer_house.code_name ].join( ', ' ) }.to_a
  end

  def test_allies_list
    @gbp.create_alliance( @stark, @greyjoy, 1 )
    @gbp2 = GGameBoardPlayer.create!
    @gbp2.set_enemies( @stark, @lannister )
    @gbp2.create_alliance( @stark, @greyjoy, 1 )
    assert_includes( @gbp.allies( @stark ).pluck( :id ), @greyjoy.id )
    assert_includes( @gbp.allies( @stark ).pluck( :id ), @pyk.id )
    refute_includes( @gbp.allies( @stark ).pluck( :id ), @stark.id )
    @gbp.create_alliance( @stark, @lannister, 1 )
    assert_includes( @gbp.allies( @lannister ).pluck( :id ), @greyjoy.id )
    assert_includes( @gbp.allies( @lannister ).pluck( :id ), @pyk.id )
    assert_includes( @gbp.allies( @lannister ).pluck( :id ), @stark.id )
  end

  def test_alliance_separation_through_game_board
    @gbp.create_alliance( @stark, @lannister, 0 )
    assert @gbp.allied?( @cendermark, @stark )
    @gbp2 = GGameBoardPlayer.create!
    refute @gbp2.allied?( @cendermark, @stark )
  end

  def test_alliances_stealing
    @gbp.create_alliance( @stark, @lannister, 0 )
    @gbp.create_alliance( @stark, @greyjoy, 0 )
    @gbp.create_alliance( @tyrell, @greyjoy, 0 )
    assert @gbp.allied?( @cendermark, @stark )
    refute @gbp.allied?( @pyk, @stark )
    refute @gbp.allied?( @pyk, @cendermark )
    assert @gbp.allied?( @pyk, @tarly )
  end

  def test_ennemies_with_alliances_stealing
    @gbp.create_alliance( @stark, @lannister, 0 )
    @gbp.create_alliance( @tyrell, @greyjoy, 0 )
    @gbp.set_enemies( @stark, @tyrell )
    assert @gbp.enemies?( @stark, @greyjoy )
    assert @gbp.enemies?( @stark, @greyjoy )
    @gbp.create_alliance( @stark, @greyjoy, 0 )
    refute @gbp.enemies?( @stark, @greyjoy )
    assert @gbp.enemies?( @tyrell, @greyjoy )
  end

  def test_advanced_alliances
    @gbp.create_alliance( @stark, @lannister, 0 )
    @gbp.create_alliance( @stark, @greyjoy, 0 )
    assert_raises {
      @gbp.create_alliance( @lannister, @tyrell, 0 )
    }
    assert @gbp.allied?( @cendermark, @stark )
    assert @gbp.allied?( @pyk, @cendermark )
    assert @gbp.allied?( @pyk, @stark )
    refute @gbp.allied?( @pyk, @tarly )
  end

  def test_basic_alliances
    assert_raises {
      @gbp.create_alliance( @stark, @cendermark, 0 )
    }
    assert_raises {
      @gbp.create_alliance( @cendermark, @stark, 0 )
    }
    @gbp.create_alliance( @stark, @lannister, 0 )
    assert @gbp.allied?( @stark, @cendermark )
    assert @gbp.allied?( @cendermark, @stark )
    assert @gbp.allied?( @karstark, @cendermark )
    assert_equal(
      [ @lannister, @cendermark, @karstark ].map{ |e| e.id }.sort, @gbp.allies( @stark ).map{ |e| e.id }.sort )

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

  def test_alliances_hash
    @gbp.create_alliance( @stark, @lannister, 1 )
    @gbp.set_enemies( @stark, @greyjoy )
    result_hash = @gbp.alliances_hash( @stark )
    assert_equal( 4, result_hash[ :allies ].count )
    assert_equal( 2, result_hash[ :enemies ].count )
    assert_equal( 2, result_hash[ :neutrals ].count )
  end


end