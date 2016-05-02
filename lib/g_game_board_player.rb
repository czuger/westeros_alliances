require 'active_record'
require_relative 'al_alliance'
require_relative 'al_house'
require_relative 'alliances_engine/g_alliances_bet_engine'
require_relative 'alliances_engine/g_alliance_core_engine'
require_relative 'assert'

class GGameBoardPlayer < ActiveRecord::Base

  # TODO : add a method that allow to add 2 ennemis
  # - don't forget to create the reverse enemy line (a -> b, b -> a)

  # TODO : Create a method that give, for one house : all allies (done), all ennemies, all neutrals

  has_many :al_alliances, dependent: :destroy
  has_many :al_houses, dependent: :destroy
  has_many :al_bets, dependent: :destroy
  has_many :al_ennemies, dependent: :destroy

  include GAlliancesBetEngine
  include GAllianceCoreEngine

  def set_ennemies( house_a, house_b )

  end

end