require 'active_record'

# This is a temporary model designed to store bet for an alliance request
module WesterosAlliances
  class AlBet < ActiveRecord::Base

    belongs_to :h_house
    belongs_to :h_target_house, class_name: 'HHouse', foreign_key: :h_target_house_id

  end
end
