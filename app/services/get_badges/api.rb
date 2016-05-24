module GetBadges
  class Api
    def self.send_data(data)
      token = Setting.plugin_redmine_get_badges['get_badges_token']
      return unless token.present?
      data[:host] = Setting.protocol + '://' + Setting.host_name
      uri = if data['projects'].present?
              URI("https://getbadges.io/api/redmine/projects/#{token}")
            else
              URI("https://getbadges.io/api/app/webhook/#{token}")
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
