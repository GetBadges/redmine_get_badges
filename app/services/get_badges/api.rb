module GetBadges
  class Api
    def self.send_data(data)
      token = Setting.plugin_redmine_get_badges['get_badges_token']
      uri = URI("http://getbadg.es/app/webhook/#{token}")
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.path, initheader = { 'Content-Type' =>'application/json' })
      req.body = [data].to_json
      http.request(req)
    rescue => e
      Rails.logger.error "Request sending error: #{e.message}"
    end
  end
end
