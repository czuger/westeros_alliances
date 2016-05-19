# require_relative 'al_alliance'
# require_relative 'al_house'
# require_relative 'al_bet'
# require_relative 'assert'
# require_relative 'al_enemy'
#
# require_relative 'alliances_engine/g_alliances_bet_engine'
# require_relative 'alliances_engine/g_enemies_core_engine'
# require_relative 'alliances_engine/g_alliance_core_engine'

class GGameBoardPlayer < ActiveRecord::Base

  belongs_to :g_game_board

end