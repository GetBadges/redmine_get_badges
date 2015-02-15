module GetBadges
  class Api
    def self.send_data(data)
      token = Setting.plugin_redmine_get_badges['get_badges_token']
      return unless token.present?
      uri = if data['projects'].present?
              URI("http://getbadg.es/api/redmine/projects/#{token}")
            else
              URI("http://getbadg.es/api/app/webhook/#{token}")
            end
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.path, initheader = { 'Content-Type' =>'application/json' })
      req.body = [data].to_json
      http.request(req)
    rescue => e
      Rails.logger.error "Request sending error: #{e.message}"
    end
  end
end
