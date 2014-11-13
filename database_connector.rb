require 'rubygems'
require 'active_record'
require 'logger'
require 'yaml'
require 'pg'


class DatabaseConnector


  def self.connect_to_database

    ActiveRecord::Base.logger = Logger.new('debug.log')
    database_configuration = YAML::load(IO.read('config/database.yml'))
    @connection =  ActiveRecord::Base.establish_connection(database_configuration['development'])


  end
end


DatabaseConnector.connect_to_database