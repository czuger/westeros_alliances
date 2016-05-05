require 'active_record'
require_relative 'al_alliance'
require_relative 'al_house'
require_relative 'al_enemy'
require_relative 'alliances_engine/g_alliances_bet_engine'
require_relative 'alliances_engine/g_alliance_core_engine'
require_relative 'alliances_engine/g_enemies_core_engine'
require_relative 'assert'

class GGameBoardPlayer < ActiveRecord::Base

  # TODO : Create a method that give, for one house : all allies (done), all ennemies, all neutrals

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
    neutrals = HHouse.where.not( id: [ allies_ids + enemies_ids ] )
    { allies: allies, enemies: enemies, neutrals: neutrals }
  end

end