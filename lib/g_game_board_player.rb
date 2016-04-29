require 'active_record'
require_relative 'al_alliance'
require_relative 'al_house'
require_relative 'alliances_engine/g_alliances_bet_engine'
require_relative 'assert'

class GGameBoardPlayer < ActiveRecord::Base

  has_many :al_alliances, dependent: :destroy
  has_many :al_houses, dependent: :destroy
  has_many :al_bets, dependent: :destroy

  include GAlliancesBetEngine

  # True if two houses are allied
  def allied?( house_a, house_b )
    AlAlliance.where( g_game_board_player_id: id, h_house_id: house_a.id, peer_house_id: house_b.id ).count >= 1
  end

  # Synonym for alliance_members
  def allies( house )
    alliance_members( house )
  end

  # Return all the alliance members for a given house
  def alliance_members( house )
    AlAlliance.where( g_game_board_player_id: id, h_house_id: house.id ).map{ |e| e.peer_house }
  end

  # Check if a house is a minor alliance member
  def minor_alliance_member?( house )
    al_house = AlHouse.find_by( g_game_board_player_id: id, h_house_id: house.id )
    al_house&.minor_alliance_member
  end

  # Create an alliance between two houses
  def create_alliance( house_a, house_b )
    [ house_a, house_b ].each do |h|
      raise "#{self.class}##{__method__} : #{h.inspect} not suzerain" if h.vassal?
    end

    raise "#{self.class}##{__method__} : #{house_a.inspect} minor alliance member" if minor_alliance_member?( house_a )

    minor_allies = ( [ house_b ] + house_b.vassals ).uniq
    all_allies = ( [ house_a ] + house_a.vassals + alliance_members( house_a ) + minor_allies ).uniq

    ActiveRecord::Base.transaction do

      # master_house and all it's vassals are marked as a minor alliance member (thus cant't ever be a master member)
      # Minor are included for coherence
      minor_allies.each do |ally|
        AlHouse.where( g_game_board_player_id: id ).find_or_create_by!( h_house_id: ally.id ) do |al_house|
          al_house.minor_alliance_member = true
        end
      end

      # We need to delete the current alliances of the minor house and all vassals
      AlAlliance.where( g_game_board_player_id: id, h_house_id: minor_allies.map{ |a| a.id } ).delete_all

      all_allies.each do |ally_m|
        all_allies.each do |ally_p|
          next if ally_m == ally_p
          AlAlliance.where( g_game_board_player_id: id, h_house_id: ally_m.id ).find_or_create_by!( peer_house_id: ally_p.id )
        end
      end
    end
  end
end