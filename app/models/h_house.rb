require 'active_record'

# This class store a house, this is the base definition of a house and is game board independent
class HHouse < ActiveRecord::Base

  has_many :vassals, class_name: HHouse, foreign_key: :h_suzerain_house_id

  # Caution : this is for all board / game_board_player
  has_many :al_enemies, class_name: 'WesterosAlliances::AlEnemy'
  has_many :al_alliances, class_name: 'WesterosAlliances::AlAlliance'

  def self.create_house_and_vassals( *code_names )
    houses = []
    main_house_name = code_names.shift
    main_house = create_house( main_house_name )
    houses << main_house
    code_names.each do |code_name|
      houses << main_house.create_vassal( code_name )
    end
    houses
  end

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
    h_suzerain_house_id
  end

  def suzerain?
    !vassal?
  end

  def self.suzerains
    HHouse.where( h_suzerain_house_id: nil )
  end

end