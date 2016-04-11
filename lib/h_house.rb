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

  def create_alliance( house )
    [ self, house ].each do |h|
      raise "#{self.class}##{__method__} : #{h} not suzerain" if h.vassal?
      raise "#{self.class}##{__method__} : #{h} not suzerain" if h.vassal?
    end

    all_allies = ( [ self ] + alliance_members + [ house ] + house.vassals ).uniq
    all_ally_ids = all_allies.map{ |e| e.id }

    # This way require a reload for each ally to take account of the alliance_master_id, so not very efficient
    # self.alliance_subject_ids = all_ally_ids - [ id ]

    all_allies.each do |ally|
      ally.ally_ids = all_ally_ids - [ ally.id ]

      # Updating alliance_master_id directly prevent the need of reloading
      # We say that the master of the alliance also have a master id : himself
      # Which mean that he is also member of it's own alliance
      ally.update_attribute( :alliance_master_id, id )
      # ally.reload # required to have the master_alliance_status
    end
  end

  def in_alliance_as_minor_member()
    AlAlliance.find_by( h_house_id: id ) != nil
  end

end