require 'net/http'
require 'uri'
require 'json'

class HerokuClips

  def self.move(app_name, target, cookies)
    #grab the clips
    clips = data_clips(cookies)

    app_clips=clips.select{|clip| clip["heroku_app_name"]==app_name}

    #moving
    app_clips.each do |clip|
      slug = clip["slug"]
      uri = URI.parse("#{base_uri}/#{slug}/move")
      request = Net::HTTP::Put.new(uri)
      request["Cookie"] = cookies
      request.set_form_data("heroku_resource_id" => target)

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end

      if response == Net::HTTPSuccess
        puts "DataClip #{clip['name']} moved to resource #{target}"
      else
        puts "result #{response.code}"
      end

      break
    end
  end

  private

    def self.base_uri
      "https://dataclips.heroku.com/api/v1/clips"
    end

    def self.data_clips(cookies)
      uri = URI.parse(base_uri)
      request = Net::HTTP::Get.new(uri)
      request["Cookie"] = cookies

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end

      if response.body.present?
        JSON.parse response.body
      else
        []
      end
    end
end
