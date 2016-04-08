require 'active_record'

class House < ActiveRecord::Base

  has_many :vassals, class_name: House, foreign_key: :suzerain_id

  def allies
    Alliance.where( 'house_id = ? or ally_id = ?', id, id )
  end

end