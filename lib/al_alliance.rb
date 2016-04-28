require 'active_record'
require_relative 'h_house'

# This is a join class that link all allied houses on a given game board
class AlAlliance < ActiveRecord::Base
  belongs_to :peer_house, class_name: 'HHouse', foreign_key: :peer_house_id
end