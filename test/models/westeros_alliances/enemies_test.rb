require 'test_helper'

require 'pp'

class EnemiesTest < ActiveSupport::TestCase

  def setup
    GGameBoard.destroy_all

    @gb = GGameBoard.create!

    @stark, @karstark = HHouse.create_house_and_vassals( :stark, :karstark )
    @lannister, @cendermark = HHouse.create_house_and_vassals( :lannister, :cendermark )
    @greyjoy, @pyk = HHouse.create_house_and_vassals( :greyjoy, :pyk )
    @tyrell, @tarly = HHouse.create_house_and_vassals( :tyrell, :tarly )
  end

  def test_ennemies_list
    @gb.set_enemies( @stark, @greyjoy )
    @gb2 = GGameBoard.create!
    @gb2.set_enemies( @stark, @lannister )
    @gb2.create_alliance( @stark, @greyjoy, 1 )
    assert_includes( @gb.enemies( @stark ).pluck( :id ), @greyjoy.id )
    assert_includes( @gb.enemies( @stark ).pluck( :id ), @pyk.id )
    refute_includes( @gb.enemies( @stark ).pluck( :id ), @stark.id )
  end

  def test_allies_become_ennemies
    @gb.create_alliance( @stark, @greyjoy, 1 )
    @gb.create_alliance( @lannister, @tyrell, 1 )

    @gb.set_enemies( @stark, @lannister )

    # pp @gb.al_alliances.all.map{ |e| [ e.h_house.code_name, e.h_peer_house.code_name ].join( ', ' ) }.to_a
    # pp @gb.al_enemies.all.map{ |e| [ e.h_house.code_name, e.h_peer_house.code_name ].join( ', ' ) }.to_a

    assert @gb.allied?( @stark, @greyjoy )
    assert @gb.allied?( @stark, @pyk )
    assert @gb.enemies?( @stark, @lannister )
    assert @gb.enemies?( @stark, @cendermark )
    assert @gb.enemies?( @karstark, @lannister )
    assert @gb.enemies?( @karstark, @tyrell )
    assert @gb.enemies?( @karstark, @cendermark )

    refute @gb.enemies?( @stark, @greyjoy )
    refute @gb.enemies?( @stark, @pyk )
    refute @gb.allied?( @stark, @lannister )
    refute @gb.allied?( @stark, @cendermark )
    refute @gb.allied?( @karstark, @lannister )
    refute @gb.allied?( @karstark, @tyrell )
    refute @gb.allied?( @karstark, @cendermark )

  end

  def test_basic_ennemies_settings
    @gb.set_enemies( @stark, @lannister )
    assert @gb.enemies?( @stark, @lannister )
    assert @gb.enemies?( @lannister, @stark )
  end

end