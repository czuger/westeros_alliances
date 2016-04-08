require_relative 'db_connect'
require_relative '../lib/house'
require_relative '../lib/alliance'

# migration.rb first (one time)

stark = House.find_or_create_by!( code_name: :stark )
karstark = stark.vassals.find_or_create_by!( code_name: :karstark )

lannister= House.find_or_create_by!( code_name: :lannister)
cendermark = lannister.vassals.find_or_create_by!( code_name: :cendermark )

tyrell = House.find_or_create_by!( code_name: :tyrell )
treille = tyrell.vassals.find_or_create_by!( code_name: :treille )

Alliance.create( house: stark, ally: lannister )

