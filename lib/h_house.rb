require 'active_record'
require_relative 'al_alliance'

class HHouse < ActiveRecord::Base

  has_many :vassals, class_name: HHouse, foreign_key: :suzerain_id

  def self.create_house( code_name )
    house = HHouse.find_or_create_by!(code_name: code_name )
    house
  end

  def create_vassal( code_name )
    vassal = HHouse.create_house( code_name )
    vassals << vassal
    vassal
  end

  def vassal?
    suzerain_id
  end

  def suzerain?
    !vassal?
  end

  def allied?( gbp, house )
    AlAlliance.where( g_game_board_player_id: gbp.id, h_house_id: id, peer_house_id: house.id ).count >= 1
  end

  def allies( gbp )
    alliance_members( gbp )
  end

  def alliance_members( gbp )
    AlAlliance.where( g_game_board_player_id: gbp.id, h_house_id: id ).map{ |e| e.peer_house }
  end

  def create_alliance( gbp, house )
    [ self, house ].each do |h|
      raise "#{self.class}##{__method__} : #{self.inspect} not suzerain" if vassal?
      raise "#{self.class}##{__method__} : #{h.inspect} not suzerain" if h.vassal?
      # raise "#{self.class}##{__method__} : #{self.inspect} minor alliance member" if alliance_master_id != id
    end

    all_allies = ( [ self ] + vassals + alliance_members( gbp ) + [ house ] + house.vassals ).uniq

    all_allies.each do |ally_m|
      all_allies.each do |ally_p|
        next if ally_m == ally_p
        alliance = AlAlliance.where( g_game_board_player_id: gbp.id, h_house_id: ally_m.id ).find_or_initialize_by( peer_house_id: ally_p.id ) do |a|
          a.g_game_board_player_id = gbp.id
          a.h_house_id = ally_m.id
        end
        alliance.peer_house_id = ally_p.id
        alliance.save!
      end
    end
  end

end