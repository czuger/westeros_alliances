require_relative 'db_connect'
require_relative '../lib/h_house'
require_relative '../lib/al_alliance'

# migration.rb first (one time)

HHouse.destroy_all

stark = HHouse.create_house( :stark )
stark.create_vassal( :karstark )

lannister = HHouse.create_house( :lannister )
lannister.create_vassal( :cendermark )

tyrell = HHouse.create_house( :tyrell )
tyrell.create_vassal( :treille )

# stark.create_alliance( tyrell )

