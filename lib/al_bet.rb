require 'active_record'
require_relative 'h_house'

# This is a temporary model designed to store bet for an alliance request
class AlBet < ActiveRecord::Base

  belongs_to :h_house
  belongs_to :h_target_house, class_name: 'HHouse', foreign_key: :h_target_house_id

end