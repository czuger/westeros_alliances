require 'test_helper'
require 'pp'

module WesterosAlliances

  class AlLogTest < ActiveSupport::TestCase

    def setup
      GGameBoard.destroy_all

      @gb = GGameBoard.create!

      @stark, @karstark = HHouse.create_house_and_vassals( :stark, :karstark )
      @lannister, @cendermark = HHouse.create_house_and_vassals( :lannister, :cendermark )
      @greyjoy, @pyk = HHouse.create_house_and_vassals( :greyjoy, :pyk )
      @tyrell, @tarly = HHouse.create_house_and_vassals( :tyrell, :tarly )
    end

    test 'Alliance stealing' do
      @gb.create_alliance( @stark, @lannister, 5 )

      @gb.set_bet( @greyjoy, @lannister, 10 )
      @gb.set_bet( @tyrell, @lannister, 20 )
      @gb.resolve_bets

      log = WesterosAlliances::AlLog.first

      assert_equal WesterosAlliances::AlLog::ALLIANCE_CREATION, log.log_code
      assert_equal 20, log[ :alliance_details ][ :best_bet ]

      pp log
    end

    test 'Test too low bet' do
      @gb.create_alliance( @stark, @lannister, 50 )

      @gb.set_bet( @greyjoy, @lannister, 10 )
      @gb.set_bet( @tyrell, @lannister, 20 )
      @gb.resolve_bets

      log = WesterosAlliances::AlLog.first

      assert_equal WesterosAlliances::AlLog::BEST_BET_TOO_LOW, log.log_code
      refute log[ :alliance_details ][ :best_bet ]
    end


    test 'Test multiple alliance bet' do
      @gb.set_bet( @greyjoy, @lannister, 10 )
      @gb.set_bet( @stark, @lannister, 20 )
      @gb.resolve_bets

      log = WesterosAlliances::AlLog.first

      assert_equal WesterosAlliances::AlLog::ALLIANCE_CREATION, log.log_code
      assert_equal 20, log[ :alliance_details ][ :best_bet ]
    end

    test 'Test single alliance bet' do
      @gb.set_bet( @greyjoy, @lannister, 10 )
      @gb.resolve_bets

      log = WesterosAlliances::AlLog.first

      assert_equal WesterosAlliances::AlLog::ALLIANCE_CREATION, log.log_code
      assert_equal 10, log[ :alliance_details ][ :best_bet ]
    end
  end

end
