require 'net/http'
require 'uri'
require 'json'

class HerokuClips

  def self.move(app_name, target, cookies, csfr_token)
    #grab the clips
    clips = data_clips(cookies)

    app_clips=clips.select{|clip| clip["heroku_app_name"]==app_name}

    #moving
    app_clips.each do |clip|
      slug = clip["slug"]
      uri = URI.parse("#{base_uri}/#{slug}/move")
      request = Net::HTTP::Post.new(uri)
      request["Cookie"] = cookies
      request["X-Csrf-Token"] = csfr_token
      request.body = JSON.dump({"heroku_resource_id" => target})

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end

      if response.code == "200"
        puts "DataClip #{clip['name']} moved to resource #{target}"
      else
        puts "Error moving #{clip['name']}, response code: #{response.code}-#{response.message}"
        puts "Please confirm that you have fresh cookies and csfr token"
        puts "Stopping..."
        #end the loop if something is bad.
        break
      end
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

      puts "Response getting clips: #{response.code}"

      if response.code == "200"
        JSON.parse response.body
      else
        []
      end
    end
end
