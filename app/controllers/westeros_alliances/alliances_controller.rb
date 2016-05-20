require_dependency "westeros_alliances/application_controller"

module WesterosAlliances
  class AlliancesController < ApplicationController

    def log
      @gb = GGameBoard.find( params[ :game_board_id ] )
      @logs = @gb.westeros_alliances_al_logs.order( 'updated_at DESC' )
    end

    def show
      @gb = GGameBoard.find( params[ :game_board_id ] )
      @suzerains = HHouse.suzerains.order( :id )

      @suzerains_names = @suzerains.map(&:code_name)
      @suzerains_ids = @suzerains.map(&:id)

      @alliances_hash = {}

      @suzerains.each do |suzerain_a|
        @alliances_hash[ suzerain_a.id ] = []
        @suzerains.each do |suzerain_b|
          @alliances_hash[ suzerain_a.id ] << alliance_status_code( suzerain_a, suzerain_b )
        end
      end
    end

    private

    def alliance_status_code( suzerain_a, suzerain_b )
      if suzerain_a == suzerain_b
        return :same
      elsif @gb.allied?( suzerain_a, suzerain_b )
        return :allied
      elsif @gb.enemies?( suzerain_a, suzerain_b )
        return :enemies
      end
      :neutral
    end

  end
end
