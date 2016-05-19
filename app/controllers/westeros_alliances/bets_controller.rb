require_dependency "westeros_alliances/application_controller"

module WesterosAlliances
  class BetsController < ApplicationController

    def logs
      @gb = GGameBoard.find( params[ :game_board_id ] )
      @logs = @gb.westeros_alliances_al_logs.order( 'updated_at DESC' )
    end

    def show
    end

    def new
      @gb = GGameBoard.find( params[ :game_board_id ] )
      @asking_house = HHouse.first
      @bets = {}

      @al_houses = @gb.al_houses.joins( :h_house ).where( 'h_houses.h_suzerain_house_id' => nil )

      # First we load the last bets for houses
      @al_houses.each do |asking_al_house|
        @al_houses.each do |target_al_house|
          next if asking_al_house.h_house_id == target_al_house.h_house_id
          @bets[ asking_al_house.h_house_id ] = {} unless @bets[ asking_al_house.h_house_id ]
          @bets[ asking_al_house.h_house_id ][ target_al_house.h_house_id ] = @gb.min_bet_value( target_al_house.last_bet )
        end
      end

      # Then we overload with current bets (if there are some)
      @gb.al_bets.each do |b|
        @bets[ b.h_house_id ] = {} unless @bets[ b.h_house_id ]
        @bets[ b.h_house_id ][ b.h_target_house_id ] = b.bet
      end

    end

    def create
      gb = GGameBoard.find( params[ :game_board_id ] )
      asking_house = HHouse.find( params[ :asking_house_id ] )

      houses_bets = params[ :houses_bets ].reject{ |_, v| v.empty? }

      ActiveRecord::Base.transaction do
        houses_bets.each do |k, v|
          gb.set_bet( asking_house, HHouse.find( k ), v ) unless asking_house.id == k.to_i
        end
      end

      redirect_to new_game_board_bets_path
    end

  end
end
