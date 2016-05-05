require 'active_record'
require_relative 'h_house'

# This is a temporary model designed to store bet for an alliance request
class AlEnemy < ActiveRecord::Base
  belongs_to :h_enemy_house, class_name: 'HHouse', foreign_key: :h_enemy_house_id
end
