require 'active_record'

# ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :username => 'feodalis',
  host: :localhost
)
