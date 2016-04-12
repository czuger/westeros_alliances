require 'active_record'
require_relative 'al_alliance'

class HHouse < ActiveRecord::Base

  has_many :vassals, class_name: HHouse, foreign_key: :suzerain_id

  belongs_to :alliance_master, class_name: HHouse, foreign_key: :alliance_master_id
  has_many :alliance_members, class_name: HHouse, foreign_key: :alliance_master_id

  has_and_belongs_to_many :allies, join_table: :al_alliances, association_foreign_key: :peer_house_id, class_name: HHouse

  def self.create_house( code_name )
    house = HHouse.find_or_create_by!(code_name: code_name )
    house.update_attributes( alliance_master_id: house.id )
    house
  end

  def create_vassal( code_name )
    vassal = HHouse.create_house( code_name )
    vassals << vassal
    allies << vassal
    vassal.allies << self
    vassal.update_attributes( alliance_master_id: id )
    vassal
  end

  def vassal?
    suzerain_id
  end

  def suzerain?
    !vassal?
  end

  def allied?( house )
    AlAlliance.where( h_house_id: id, peer_house_id: house.id ).count >= 1
  end

  def create_alliance( house )
    [ self, house ].each do |h|
      raise "#{self.class}##{__method__} : #{self.inspect} not suzerain" if vassal?
      raise "#{self.class}##{__method__} : #{h.inspect} not suzerain" if h.vassal?
      raise "#{self.class}##{__method__} : #{self.inspect} minor alliance member" if alliance_master_id != id
    end

    all_allies = ( [ self ] + alliance_members + [ house ] + house.vassals ).uniq
    all_ally_ids = all_allies.map{ |e| e.id }

    self.alliance_member_ids = all_ally_ids

    all_allies.each do |ally|
      ally.ally_ids = all_ally_ids - [ ally.id ]
    end
  end

  # # Alliances group for display
  # def self.alliances_groups
  #   HHouse.all.group_by( &:alliance_master )
  # end

end