



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


require_all 'parsers'
require_all 'models'







p 'start'

@@config  =       Psych.load_file( "./config/config.yml" )


def start
  parser1=  SzkoParser.new
  parser1.parse

  pasers = [AzbukaParser.new,
            ExmoParser.new,
            PiterParser.new,
            SzkoParser.new,
             ]

 parser.each do |parser|
   parser.parse
 end
end


start











