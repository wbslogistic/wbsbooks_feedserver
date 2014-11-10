
class LittleService






  def self.get_eskmo_xml

    #todo: need to add pagination

    response = HTTParty.get("https://partners.eksmo.ru/wservices/xml/v1/?key=#{@@config["eksmo_key"]}&action=products_full&full=y")

   test = 33
  end

end

#
# class EskmoService
#   include HTTParty
#   base_uri 'https://partners.eksmo.ru/wservices/xml/v1'
#   timeout  120000
#   format :xml
#
#
#   def getAll()
#     EskmoService.get("/members/#{memberId}", :query => {"api-key" => @apikey})
#   end
#
#
# end


