
require 'RMagick'

require 'rubygems'
require 'require_all'

require 'psych' # for reading yml
require 'open-uri'
require 'zip/zip'
require 'spreadsheet' # best for large xls

require_all "parsers"
require_all 'models'
require_all 'helpers'
require 'net/http'



require 'net/ftp'
require 'httparty'
require "xml"
require "./database_connector"


@@config  =       Psych.load_file( "./config/config.yml" )


DatabaseConnector.connect_to_database

