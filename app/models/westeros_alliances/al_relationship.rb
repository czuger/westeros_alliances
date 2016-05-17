# This is a join class that link all allied houses on a given game board
class AlRelationship < ActiveRecord::Base
  belongs_to :h_house
  belongs_to :h_peer_house, class_name: 'HHouse', foreign_key: :h_peer_house_id
end