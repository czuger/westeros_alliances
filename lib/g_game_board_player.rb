require_relative 'al_alliance'
require_relative 'al_house'
require_relative 'al_bet'
require_relative 'al_enemy'
require_relative 'assert'

require_relative 'alliances_engine/g_alliances_bet_engine'
require_relative 'alliances_engine/g_enemies_core_engine'
require_relative 'alliances_engine/g_alliance_core_engine'

class GGameBoardPlayer < ActiveRecord::Base

  has_many :al_alliances, dependent: :destroy
  has_many :al_houses, dependent: :destroy
  has_many :al_bets, dependent: :destroy
  has_many :al_enemies, dependent: :destroy

  include GAlliancesBetEngine
  include GAllianceCoreEngine
  include GEnemiesCoreEngine

  # give all allies, enemies or neutral houses for a house
  def alliances_hash( house )
    allies = allies( house )
    allies_ids = allies.map{ |e| e.id }
    enemies = al_enemies.where( h_house_id: house.id ).map{ |e| e.h_enemy_house }
    enemies_ids = enemies.map{ |e| e.id }
    neutrals = HHouse.where.not( id: allies_ids + enemies_ids )
    { allies: allies, enemies: enemies, neutrals: neutrals }
  end

  private

  # Only master houses can negociate
  # Input : a hash of houses
  def can_negotiate?( house_a, house_b )
    [ house_a, house_b ].each do |h|
      raise "#{self.class}##{__method__} : #{h.inspect} not suzerain" if h.vassal?
    end

    raise "#{self.class}##{__method__} : #{house_a.inspect} minor alliance member" if minor_alliance_member?( house_a )
  end

end