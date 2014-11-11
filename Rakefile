

require 'active_record_migrations'
require "yaml"
require "mysql2"



ActiveRecordMigrations.configure do |c|

  #c.database_configuration = YAML.load_file('config/database.yml')["production"]
  # Other settings:
   #c.schema_format = :sql # default is :ruby
   c.yaml_config = './config/database.yml'
  # c.environment = ENV['db']
  # c.db_dir = 'db'
  # c.migrations_paths = ['db/migrate'] # the first entry will be used by the generator
end


ActiveRecordMigrations.load_tasks