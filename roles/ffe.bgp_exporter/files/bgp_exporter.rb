#!/usr/bin/ruby
require 'rack'
require 'rack/server'

class BgpExporter
  def self.get_states(router)
    regex = /((?:[0-9]{1,3}\.){3}[0-9]{1,3}) = INTEGER: ([0-6])/
    result = "# HELP bgpStatus BGP session status\n# TYPE bgpStatus untyped\n"

    IO.popen("snmpwalk -v1 -c hd7k30dl3w892 #{router} 1.3.6.1.2.1.15.3.1.2") do |p|
      p.each do |l|
        m = l.match(regex)

        if m
          result += "bgpStatus{peerIpAddr=\"#{m[1]}\"} #{m[2]}.0\n"
        end
      end
    end

    result
  end

  def self.call(env)
    r = Rack::Request.new(env)

    [200, {}, [get_states(r.params['address'])]]
  end
end

Rack::Server.start :app => BgpExporter
