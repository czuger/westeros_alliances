require_dependency "westeros_alliances/application_controller"

module WesterosAlliances
  class BetsController < ApplicationController

    def show
    end

    def new
      gb = GGameBoard.find( params[ :game_board_id ] )
      @asking_house = HHouse.first
      @bets = {}
      gb.al_bets.each do |b|
        @bets[ b.h_house_id ] = {} unless @bets[ b.h_house_id ]
        @bets[ b.h_house_id ][ b.h_target_house_id ] = b.bet
      end
    end

    def create
      gb = GGameBoard.find( params[ :game_board_id ] )
      asking_house = HHouse.find( params[ :asking_house ] )

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
