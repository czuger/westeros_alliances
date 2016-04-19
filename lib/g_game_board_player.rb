require 'active_record'
require_relative 'al_alliance'

class GGameBoardPlayer < ActiveRecord::Base

  has_many :al_alliances, dependent: :destroy

  def create_alliance( house_a, house_b )
    [ house_a, house_b ].each do |h|
      raise "#{self.class}##{__method__} : #{h.inspect} not suzerain" if h.vassal?
      # raise "#{self.class}##{__method__} : #{self.inspect} minor alliance member" if alliance_master_id != id
    end

    all_allies = ( [ house_a ] + house_a.vassals + house_a.alliance_members( self ) + [ house_b ] + house_b.vassals ).uniq

    all_allies.each do |ally_m|
      all_allies.each do |ally_p|
        next if ally_m == ally_p
        alliance = AlAlliance.where( g_game_board_player_id: id, h_house_id: ally_m.id ).find_or_initialize_by( peer_house_id: ally_p.id ) do |a|
          a.g_game_board_player_id = id
          a.h_house_id = ally_m.id
        end
        alliance.peer_house_id = ally_p.id
        alliance.save!
      end
    end
  end

end