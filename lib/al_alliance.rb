require 'active_record'

class AlAlliance < ActiveRecord::Base
  belongs_to :master, class_name: 'HHouse', foreign_key: :master_id
  belongs_to :h_house
end