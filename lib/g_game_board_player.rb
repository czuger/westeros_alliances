require 'active_record'
require_relative 'al_alliance'
require_relative 'al_house'
require_relative 'alliances_engine/g_alliances_bet_engine'
require_relative 'alliances_engine/g_alliance_core_engine'
require_relative 'assert'

class GGameBoardPlayer < ActiveRecord::Base

  has_many :al_alliances, dependent: :destroy
  has_many :al_houses, dependent: :destroy
  has_many :al_bets, dependent: :destroy

  include GAlliancesBetEngine
  include GAllianceCoreEngine

end