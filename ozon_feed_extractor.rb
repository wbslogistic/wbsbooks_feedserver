
# xls readers
#require 'creek' # to read large xls
#require 'roo'
#require "simple-spreadsheet"
#require 'nokogiri'

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
#require 'ox'


require 'httparty'

require "xml"

require "./database_connector"



puts ' ------- Feed extractor started ------- '

@@config  =       Psych.load_file( "./config/config.yml" )


def start
  #Product.destroy_all

  parsers = [ AzbukaParser.new,ExmoParser.new, SzkoParser.new   ,  PiterParser.new  ]

  parsers.each do |parser|
     parser.parse
 end
end


def n_times message
  @@config["times_to_try"].to_i.times do |t|
    begin
      yield
      break
    rescue Exception => ex
      mes =  " Exception message #{ message}  Exception content: #{ex.message.to_s}"
      Helper.log_and mes
    end
  end
end



DatabaseConnector.connect_to_database


start











