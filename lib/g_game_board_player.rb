require 'active_record'
require_relative 'al_alliance'

class GGameBoardPlayer < ActiveRecord::Base
  has_many :al_alliances, dependent: :destroy
end