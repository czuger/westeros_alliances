require_relative 'db/db_connect'
require_relative 'lib/h_house'
require_relative 'lib/al_alliance'
require 'pp'

pp HHouse.first.vassals

pp HHouse.find_by_code_name( ).allies
pp HHouse.all[1 ].allies