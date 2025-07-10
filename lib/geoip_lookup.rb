require 'net/http'
require 'json'
require 'uri'

module ZPZ
  class GeoIPLookup
    def self.lookup(ip)
      return if $ZPZ_SILENT == true

      puts "\n[+] IP Geolocation Lookup for #{ip}"
      output_lines = []

      begin
        uri = URI("http://ip-api.com/json/#{ip}?fields=status,message,continent,country,regionName,city,org,isp,query")
        response = Net::HTTP.get_response(uri)
        data = JSON.parse(response.body)

        if data["status"] == "success"
          output_lines << "    - Country    : #{data['country']}"
          output_lines << "    - Region     : #{data['regionName']}"
          output_lines << "    - City       : #{data['city']}"
          output_lines << "    - ISP        : #{data['isp']}"
          output_lines << "    - Org        : #{data['org']}"
          output_lines << "    - Continent  : #{data['continent']}"
        else
          output_lines << "    - GeoIP failed: #{data['message'] || 'Unknown error'}"
        end

      rescue Net::ReadTimeout, Timeout::Error
        output_lines << "    - GeoIP lookup timeout. Trying fallback API..."

        # Fallback: ipwho.is
        begin
          fallback_uri = URI("https://ipwho.is/#{ip}")
          fallback_response = Net::HTTP.get_response(fallback_uri)
          fallback_data = JSON.parse(fallback_response.body)

          if fallback_data["success"]
            output_lines << "    - Country    : #{fallback_data['country']}"
            output_lines << "    - Region     : #{fallback_data['region']}"
            output_lines << "    - City       : #{fallback_data['city']}"
            output_lines << "    - ISP        : #{fallback_data['connection']['isp'] rescue 'N/A'}"
            output_lines << "    - Org        : #{fallback_data['connection']['org'] rescue 'N/A'}"
            output_lines << "    - Continent  : #{fallback_data['continent']}"
          else
            output_lines << "    - Fallback GeoIP failed: #{fallback_data['message'] || 'Unknown error'}"
          end

        rescue => e2
          output_lines << "    - Fallback GeoIP error: #{e2.message}"
        end

      rescue => e
        output_lines << "    - GeoIP lookup failed: #{e.message}"
      end

      puts output_lines.join("\n")
      File.open("output/results.txt", "a") { |f| f.puts(output_lines.join("\n")) }
    end
  end
end
