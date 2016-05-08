require_relative 'test_helper'

require_relative '../lib/h_house'
require_relative '../lib/al_alliance'
require_relative '../lib/g_game_board_player'

require 'pp'

class EnemiesTest < ActiveSupport::TestCase

  def setup
    GGameBoardPlayer.destroy_all
    @gbp = GGameBoardPlayer.create!

    @stark, @karstark = HHouse.create_house_and_vassals( :stark, :karstark )
    @lannister, @cendermark = HHouse.create_house_and_vassals( :lannister, :cendermark )
    @greyjoy, @pyk = HHouse.create_house_and_vassals( :greyjoy, :pyk )
    @tyrell, @tarly = HHouse.create_house_and_vassals( :tyrell, :tarly )
  end

  def test_ennemies_list
    @gbp.set_enemies( @stark, @greyjoy )
    @gbp2 = GGameBoardPlayer.create!
    @gbp2.set_enemies( @stark, @lannister )
    @gbp2.create_alliance( @stark, @greyjoy, 1 )
    assert_includes( @gbp.enemies( @stark ).pluck( :id ), @greyjoy.id )
    assert_includes( @gbp.enemies( @stark ).pluck( :id ), @pyk.id )
    refute_includes( @gbp.enemies( @stark ).pluck( :id ), @stark.id )
  end

  def test_allies_become_ennemies
    @gbp.create_alliance( @stark, @greyjoy, 1 )
    @gbp.create_alliance( @lannister, @tyrell, 1 )

    @gbp.set_enemies( @stark, @lannister )

    # pp @gbp.al_alliances.all.map{ |e| [ e.h_house.code_name, e.h_peer_house.code_name ].join( ', ' ) }.to_a
    # pp @gbp.al_enemies.all.map{ |e| [ e.h_house.code_name, e.h_peer_house.code_name ].join( ', ' ) }.to_a


    assert @gbp.allied?( @stark, @greyjoy )
    assert @gbp.allied?( @stark, @pyk )
    assert @gbp.enemies?( @stark, @lannister )
    assert @gbp.enemies?( @stark, @cendermark )
    assert @gbp.enemies?( @karstark, @lannister )
    assert @gbp.enemies?( @karstark, @tyrell )
    assert @gbp.enemies?( @karstark, @cendermark )

    refute @gbp.enemies?( @stark, @greyjoy )
    refute @gbp.enemies?( @stark, @pyk )
    refute @gbp.allied?( @stark, @lannister )
    refute @gbp.allied?( @stark, @cendermark )
    refute @gbp.allied?( @karstark, @lannister )
    refute @gbp.allied?( @karstark, @tyrell )
    refute @gbp.allied?( @karstark, @cendermark )

  end

  def test_basic_ennemies_settings
    @gbp.set_enemies( @stark, @lannister )
    assert @gbp.enemies?( @stark, @lannister )
    assert @gbp.enemies?( @lannister, @stark )
  end

end