require 'active_record'

class Alliance < ActiveRecord::Base
  belongs_to :house
  belongs_to :ally, class_name: House, foreign_key: :ally_id
end