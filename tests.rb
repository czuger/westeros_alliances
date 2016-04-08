require_relative 'db/db_connect'
require_relative 'lib/house'
require_relative 'lib/alliance'
require 'pp'

pp House.first.vassals

pp House.first.allies