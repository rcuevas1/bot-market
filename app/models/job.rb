class Job < ApplicationRecord
  belongs_to :user

  def get_response_html
    require "uri"
    require 'net/http'

    url = URI.parse('http://storage.scrapinghub.com/requests/'<<self.shub_job_id<<"/7?apikey=5a5b950611aa4dfe8ec385e7c47cb1b3")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    res

    response_hash = JSON.parse res.body
    info_url = response_hash["url"] #this url contains the info we want to extract
    
  end
end

#curl -u 5a5b950611aa4dfe8ec385e7c47cb1b3: https://storage.scrapinghub.com/requests/291591/3/6