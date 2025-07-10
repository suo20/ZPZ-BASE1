require 'whois'
require 'whois-parser'

module ZPZ
  class WhoisLookup
    def self.lookup(domain)
      return if $ZPZ_SILENT == true

      puts "\n[+] WHOIS Lookup for #{domain}"
      output_lines = []

      begin
        client = Whois::Client.new(timeout: 10)
        record = client.lookup(domain)

        begin
          parsed = record.parser

          output_lines << "    - Domain: #{parsed.domain rescue 'N/A'}"
          output_lines << "    - Registrar: #{parsed.registrar.name rescue 'N/A'}"
          output_lines << "    - Created On: #{parsed.created_on rescue 'N/A'}"
          output_lines << "    - Updated On: #{parsed.updated_on rescue 'N/A'}"
          output_lines << "    - Expires On: #{parsed.expires_on rescue 'N/A'}"

          output_lines << "    - Name Servers:"
          if parsed.nameservers.any?
            parsed.nameservers.each { |ns| output_lines << "      • #{ns}" }
          else
            output_lines << "      • Not listed"
          end

          output_lines << "    - Status:"
          if parsed.status.is_a?(Array)
            parsed.status.each { |s| output_lines << "      • #{s}" }
          else
            output_lines << "      • #{parsed.status rescue 'N/A'}"
          end

        rescue Whois::ParserError => e
          output_lines << "    - WHOIS parser unavailable for this domain. Raw data shown below:"
          record.to_s.lines.each do |line|
            output_lines << "    > #{line.strip}"
          end
        end

      rescue => e
        output_lines << "    - WHOIS lookup failed: #{e.message}"
      end

      puts output_lines.join("\n")
      File.open("output/results.txt", "a") { |f| f.puts(output_lines.join("\n")) }
    end
  end
end
