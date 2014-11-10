
require 'rubygems'
require 'psych' # for reading yml
require 'open-uri'


@@config  =       Psych.load_file( "./config/config.yml" )




class OzonUploader#only for style

  def self.start
    open(@@config["ozon_books_url"]) do |fin|
      open(@@config["ozon_big_xml"] , "w") do |fout|
        while (buf = fin.read(8192))
          fout.write buf
        end
      end
    end
  end

end


OzonUploader.start

