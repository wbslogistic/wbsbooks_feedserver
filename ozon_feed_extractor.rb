

require 'RMagick'

require 'rubygems'
require 'require_all'

require 'psych' # for reading yml
require 'open-uri'
require 'zip/zip'

 # xls readers
#require 'creek' # to read large xls
#require 'roo'
#require "simple-spreadsheet"

require 'spreadsheet' # best for large xls
require 'nokogiri'



require_all "parsers"
require_all 'models'
require_all 'helpers'



require 'net/ftp'
#require 'ox'


require 'httparty'

require "xml"

require "./database_connector"







p 'start'

@@config  =       Psych.load_file( "./config/config.yml" )


def start

  par =  PiterParser.new


  par.parse



  parsers = [AzbukaParser.new,
            ExmoParser.new,
            PiterParser.new,
            SzkoParser.new,
             ]

  parsers.each do |parser|
 #  parser.parse
    p parser.to_s
 end
end

DatabaseConnector.connect_to_database


start











