require 'minitest/autorun'

require_relative '../db/db_connect'
require_relative '../lib/h_house'
require_relative '../lib/al_alliance'
require_relative '../lib/g_game_board_player'
require 'pp'

class TestEnemies < Minitest::Test

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

  def test_alliances_hash
    @gbp.create_alliance( @stark, @lannister, 1 )
    @gbp.set_enemies( @stark, @greyjoy )
    result_hash = @gbp.alliances_hash( @stark )
    # pp result_hash
  end

  def test_allies_become_ennemies
    @gbp.create_alliance( @stark, @greyjoy, 1 )
    @gbp.create_alliance( @lannister, @tyrell, 1 )
    @gbp.set_enemies( @stark, @lannister )
    refute @gbp.allied?( @stark, @lannister )
    refute @gbp.allied?( @stark, @cendermark )
    assert @gbp.allied?( @stark, @greyjoy )
    assert @gbp.allied?( @stark, @pyk )
    assert @gbp.enemies?( @karstark, @cendermark )
  end

  def test_basic_ennemies_settings
    @gbp.set_enemies( @stark, @lannister )
    assert @gbp.enemies?( @stark, @lannister )
    assert @gbp.enemies?( @lannister, @stark )
  end

end