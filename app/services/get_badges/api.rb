module GetBadges
  class Api
    def self.send_data(data)
      uri = URI('http://getbadg.es/api/app/event/token')
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.path, initheader = { 'Content-Type' =>'application/json' })
      req.body = [data].to_json
      res = http.request(req)
    rescue => e
      Rails.logger.error "Request sending error: #{e.message}"
    end
  end
end
