
require 'rubygems'

require 'require_all'
require 'psych' # for reading yml
require 'open-uri'


require_all 'models'
require_all 'helpers'
require_all 'parsers'


require "xml"
require "./database_connector"

@@config  =       Psych.load_file( "./config/config.yml" )

class OzonUploader#only for style


  def self.start


 # OProduct.destroy_all
 # puts "products destroyed"
 # a = 33 + "asdfadsf"

    if (File.exist? @@config["ozon_big_xml"])
      File.delete @@config["ozon_big_xml"]
       Helper.log_and " Old ozon file deleted! "
    end


    t1 = DateTime.now
     kb =1
    n_times do
      Helper.log_and " Start uploading file "

        open(@@config["ozon_books_url"]) do |fin|
          open(@@config["ozon_big_xml"] , "w") do |fout|
            while (buf = fin.read(8192))
              fout.write buf
            end
          end
        end
    end

    t2 = DateTime.now

    Helper.log_and " Upload ozon done min: #{ ((t2.hour-t1.hour)*60 + t2.min-t1.min)  }"

  end #function end
end



def n_times
  @@config["times_to_try"].to_i.times do |t|
    begin
      yield
      break
    rescue Exception => ex
      p " Exception on uploading file " + ex.message.to_s
      Helper.log " Exception on uploading file " + ex.message.to_s
    end
  end
end



OzonUploader.start

puts "file downloaded !"
puts "start parsing big xml !"

parser =  OzonParser.new
parser.parse

puts " process finished!!! "

