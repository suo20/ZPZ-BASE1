require 'resolv'

module ZPZ
  class DNSLookup
    def self.lookup(domain)
      puts "\n[+] DNS Lookup for #{domain}"
      resolver = Resolv::DNS.new

      begin
        # A Records (IPv4)
        a_records = resolver.getresources(domain, Resolv::DNS::Resource::IN::A)
        if a_records.any?
          puts "    - A Records (IPv4):"
          a_records.each { |record| puts "      • #{record.address}" }
        else
          puts "    - No A records found."
        end

        # AAAA Records (IPv6)
        aaaa_records = resolver.getresources(domain, Resolv::DNS::Resource::IN::AAAA)
        if aaaa_records.any?
          puts "    - AAAA Records (IPv6):"
          aaaa_records.each { |record| puts "      • #{record.address}" }
        end

        # MX Records (Mail)
        mx_records = resolver.getresources(domain, Resolv::DNS::Resource::IN::MX)
        if mx_records.any?
          puts "    - MX Records:"
          mx_records.each { |record| puts "      • #{record.exchange.to_s} (Priority: #{record.preference})" }
        end

        # NS Records (Name Servers)
        ns_records = resolver.getresources(domain, Resolv::DNS::Resource::IN::NS)
        if ns_records.any?
          puts "    - NS Records:"
          ns_records.each { |record| puts "      • #{record.name.to_s}" }
        end

        # CNAME Record (Canonical Name)
        cname_records = resolver.getresources(domain, Resolv::DNS::Resource::IN::CNAME)
        if cname_records.any?
          puts "    - CNAME Record:"
          cname_records.each { |record| puts "      • #{record.name.to_s}" }
        end

      rescue => e
        puts "    - DNS Lookup failed: #{e.message}"
      end
    end
  end
end
