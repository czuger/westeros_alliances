require_relative 'db_connect'
require_relative '../lib/h_house'
require_relative '../lib/al_alliance'
require 'pp'

# migration.rb first (one time)

HHouse.destroy_all

stark = HHouse.create_house( :stark )
stark.create_vassal( :karstark )

lannister = HHouse.create_house( :lannister )
lannister.create_vassal( :cendermark )

tyrell = HHouse.create_house( :tyrell )
treille = tyrell.create_vassal( :treille )

greyjoy = HHouse.create_house( :greyjoy )
poulpe = greyjoy.create_vassal( :poulpe )

stark.create_alliance( tyrell )

# tyrell.reload

puts 'Alliance master'
puts "Tyrell = #{tyrell.alliance_master.inspect}"
puts "Treille = #{treille.alliance_master.inspect}"

puts 'Allies'
pp tyrell.allies


lannister.create_alliance( tyrell )
# tyrell.reload

puts 'Alliance master'
puts "Tyrell = #{tyrell.alliance_master.inspect}"
puts "Treille = #{treille.alliance_master.inspect}"

puts 'Allies'
pp tyrell.allies

lannister.create_alliance( greyjoy )
# tyrell.reload

puts 'Alliance master'
puts "Tyrell = #{tyrell.alliance_master.inspect}"
puts "Treille = #{treille.alliance_master.inspect}"

puts 'Allies'
pp tyrell.reload.allies

stark.create_alliance( greyjoy )
# tyrell.reload

puts 'Alliance master'
puts "Tyrell = #{tyrell.alliance_master.inspect}"
puts "Treille = #{treille.alliance_master.inspect}"

puts 'Allies'
pp tyrell.reload.allies

puts 'Stark allies'
pp stark.reload.allies


