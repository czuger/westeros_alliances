require 'active_record'

class AlHouse < ActiveRecord::Base

  belongs_to :alliance_master, class_name: HHouse, foreign_key: :alliance_master_id
  has_many :alliance_members, class_name: HHouse, foreign_key: :alliance_master_id

end