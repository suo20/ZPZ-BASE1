require 'socket'
require 'timeout'

module ZPZ
  class PortScanner
    COMMON_PORTS = {
      21 => "FTP", 22 => "SSH", 23 => "Telnet", 25 => "SMTP",
      53 => "DNS", 80 => "HTTP", 110 => "POP3", 143 => "IMAP",
      443 => "HTTPS", 3306 => "MySQL", 3389 => "RDP",
      8080 => "HTTP-Alt", 8443 => "HTTPS-Alt", 5900 => "VNC",
      139 => "NetBIOS", 445 => "SMB", 111 => "RPC",
      995 => "POP3S", 993 => "IMAPS"
    }

    def self.scan(ip)
      puts "\n[+] Port Scan for #{ip} (TCP)" unless $ZPZ_SILENT
      threads = []

      COMMON_PORTS.each do |port, service|
        threads << Thread.new do
          begin
            Timeout.timeout(1) do
              socket = TCPSocket.new(ip, port)
              socket.close
              puts "    - Port #{port} (#{service}) is OPEN"
            end
          rescue Errno::ECONNREFUSED
            puts "    - Port #{port} (#{service}) is CLOSED" if $ZPZ_VERBOSE
          rescue Timeout::Error
            puts "    - Port #{port} (#{service}) is FILTERED" if $ZPZ_VERBOSE
          rescue => e
            puts "    - Error on port #{port}: #{e.message}" if $ZPZ_VERBOSE
          end
        end
      end

      threads.each(&:join)
    end
  end
end
