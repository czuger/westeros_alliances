require 'active_record'
require_relative 'al_alliance'

class HHouse < ActiveRecord::Base

  has_many :vassals, class_name: HHouse, foreign_key: :suzerain_id
  has_many :al_alliances, foreign_key: :master_id, dependent: :destroy
  has_many :allies, through: :al_alliances, class_name: 'HHouse', source: :h_house

  def self.create_house( code_name )
    HHouse.find_or_create_by!(code_name: code_name )
  end

  def create_vassal( code_name )
    vassal = HHouse.create_house( code_name )
    vassals << vassal
  end

  def vassal?
    suzerain_id
  end

  def suzerain?
    !vassal?
  end

  # TODO : alliances only with master, create a method to get all houses in an alliance
  #
  # def create_alliance( house )
  #   [ self, house ].each do |h|
  #     raise "#{self.class}##{__method__} : #{h} not suzerain" if h.vassal?
  #     raise "#{self.class}##{__method__} : #{h} not suzerain" if h.vassal?
  #     raise "#{self.class}##{__method__} : #{h} minor in alliance" if h.in_alliance_as_minor_member
  #     raise "#{self.class}##{__method__} : #{h} minor in alliance" if h.in_alliance_as_minor_member
  #   end
  #
  #   allies_ids = house.allies.pluck( :id ) + house.vassals.pluck( :id ) + [ house.id ]
  #   # AlAlliance.where( h_house_id: house.allies.pluck( :id ) ).update_all( master_id: id )
  #   allies_ids.each do |ally_id|
  #     AlAlliance.find_by( )
  #     AlAlliance.find_or_create_by( : 'PenÃ©lope')
  #   end
  #
  #
  # end

  def in_alliance_as_minor_member()
    AlAlliance.find_by( h_house_id: id ) != nil
  end

end