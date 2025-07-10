require 'resolv'

module ZPZ
  class SubdomainFinder
    def self.find(domain, wordlist_path = "data/subdomains.txt")
      puts "\n[+] Subdomain Finder for #{domain}" unless $ZPZ_SILENT

      unless File.exist?(wordlist_path)
        puts "    - Wordlist not found: #{wordlist_path}"
        return
      end

      subdomains = File.readlines(wordlist_path).map(&:strip).reject(&:empty?)
      threads = []

      subdomains.each do |sub|
        threads << Thread.new do
          full = "#{sub}.#{domain}"
          begin
            ip = Resolv.getaddress(full)
            puts "    - Found: #{full} -> #{ip}"
          rescue Resolv::ResolvError
            puts "    - Not found: #{full}" if $ZPZ_VERBOSE
          end
        end
      end

      threads.each(&:join)
    end
  end
end
