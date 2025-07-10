#!/usr/bin/env ruby

require 'optparse'
require 'resolv'
require 'fileutils'
require 'time'

require_relative 'lib/dns_lookup'
require_relative 'lib/whois_lookup'
require_relative 'lib/geoip_lookup'
require_relative 'lib/port_scanner'
require_relative 'lib/subdomain_finder'

# Default options
options = {
  domain: nil,
  output: "output/results.txt",
  run_all: true,
  dns: false,
  whois: false,
  geoip: false,
  portscan: false,
  subdomain: false,
  verbose: false,
  silent: false
}

# Banner
def banner
  puts <<~BANNER

    🛰️  ZPZ (Base 1) by YuiKo
    =============================
    Reconnaissance Toolkit - Ruby
    Version : 1.0
    Author  : YuiKo 🐾

  BANNER
end

# Option parsing
OptionParser.new do |opts|
  opts.banner = "Usage: ruby zpz.rb [options]"

  opts.on("-dDOMAIN", "--domain=DOMAIN", "Target domain") { |d| options[:domain] = d }
  opts.on("-oFILE", "--output=FILE", "Output file (default: output/results.txt)") { |o| options[:output] = o }

  opts.on("--dns", "Run DNS Lookup") { options[:dns] = true; options[:run_all] = false }
  opts.on("--whois", "Run WHOIS Lookup") { options[:whois] = true; options[:run_all] = false }
  opts.on("--geoip", "Run IP Geolocation") { options[:geoip] = true; options[:run_all] = false }
  opts.on("--portscan", "Run Port Scan") { options[:portscan] = true; options[:run_all] = false }
  opts.on("--subdomain", "Run Subdomain Finder") { options[:subdomain] = true; options[:run_all] = false }

  opts.on("--verbose", "Verbose mode (show all output)") { options[:verbose] = true }
  opts.on("--silent", "Silent mode (only essential output)") { options[:silent] = true }

  opts.on("-h", "--help", "Show help message") do
    puts opts
    exit
  end
end.parse!

# Check conflict
if options[:verbose] && options[:silent]
  puts "[!] Error: Cannot use --verbose and --silent at the same time!"
  exit
end

# Global flags
$ZPZ_VERBOSE = options[:verbose]
$ZPZ_SILENT  = options[:silent]

# Banner
banner

# Ask for domain if not given
if options[:domain].nil? || options[:domain].empty?
  print "Enter target domain: "
  options[:domain] = gets.chomp.strip
end

# Setup output path
output_path = options[:output]
FileUtils.mkdir_p(File.dirname(output_path))
File.write(output_path, "") # Reset file

def log(line, path)
  puts line unless $ZPZ_SILENT
  File.open(path, 'a') { |f| f.puts(line) }
end

# Try IPv4 only
def resolve_ipv4(domain)
  Resolv::DNS.open do |dns|
    ress = dns.getresources(domain, Resolv::DNS::Resource::IN::A)
    return ress.first.address.to_s if ress.any?
  end
  nil
end

# Start
start_time = Time.now
log("[*] Started at: #{start_time}", output_path)
log("[*] Target: #{options[:domain]}", output_path)

ip = resolve_ipv4(options[:domain])
if ip.nil?
  log("[!] Failed to resolve IPv4. Target may only have IPv6 or DNS error.", output_path)
  exit
end
log("[*] Resolved IPv4: #{ip}", output_path)

# Run tools
ZPZ::DNSLookup.lookup(options[:domain]) if options[:run_all] || options[:dns]
ZPZ::WhoisLookup.lookup(options[:domain]) if options[:run_all] || options[:whois]
ZPZ::GeoIPLookup.lookup(ip) if options[:run_all] || options[:geoip]
ZPZ::PortScanner.scan(ip) if options[:run_all] || options[:portscan]
ZPZ::SubdomainFinder.find(options[:domain]) if options[:run_all] || options[:subdomain]

# Done
end_time = Time.now
duration = (end_time - start_time).round(2)
log("[*] Finished at: #{end_time}", output_path)
log("[*] Duration: #{duration} seconds", output_path)
log("[*] Output saved to: #{output_path}", output_path)
