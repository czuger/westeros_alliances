require_relative 'db_connect'
require_relative '../lib/h_house'
require_relative '../lib/al_alliance'
require 'pp'

# migration.rb first (one time)

HHouse.destroy_all

HHouse.destroy_all
@stark = HHouse.create_house( :stark )
@karstark = @stark.create_vassal( :karstark )
@lannister = HHouse.create_house( :lannister )
@cendermark = @lannister.create_vassal( :cendermark )
@greyjoy = HHouse.create_house( :greyjoy )
@pyk = @greyjoy.create_vassal( :pyk )
@tyrell = HHouse.create_house( :tyrell )
@tarly = @tyrell.create_vassal( :tarly )
