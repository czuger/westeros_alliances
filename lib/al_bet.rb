require 'active_record'
require_relative 'h_house'

# This is a temporary model designed to store bet for an alliance request
class AlBet < ActiveRecord::Base

  belongs_to :master_house, class_name: 'HHouse', foreign_key: :h_master_house_id
  belongs_to :target_house, class_name: 'HHouse', foreign_key: :h_target_house_id

end