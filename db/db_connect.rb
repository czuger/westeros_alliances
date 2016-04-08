require 'active_record'
require 'sqlite3'

# ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database  => 'test.db'
)
