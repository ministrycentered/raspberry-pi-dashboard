#!/usr/bin/env ruby

require "net/http/server"
require "net/http"
require "uri"
require "cgi"
require "pp"

API_KEY = "ulxMkC8k3VpkBemqPmuu"
PORT = 8039
DEFAULT_PAGE = "https://weather.com"

def set_kiosk_url(url)
  puts "Setting new kiosk URL: #{url}"
  `killall chromium-browser`
  fork { exec("DISPLAY=:0 chromium-browser --fast --fast-start --no-first-run --noerrdialogs --disable-infobars --incongnito -kiosk #{url} &") }
  return
end

def render(status: 200, body:)
  puts "rendering: #{status} - #{body}"
  [status, {"Content-Type" => "text/html"}, ["#{body}"]]
end

def valid_url?(url)
  url =~ /\A#{URI::regexp(['http', 'https'])}\z/
end

set_kiosk_url(DEFAULT_PAGE)

puts "Starting up server on port #{PORT}"
Net::HTTP::Server.run(port: PORT) do |request,stream|
  # pp request
  query_string = request.dig(:uri, :query).to_s
  query_params = CGI::parse( query_string ).map{ |k,v| [k, v[0]] }.to_h
  url = query_params["url"].to_s
  #puts query_params.inspect

  next render(status: 401, body: "Invalid api_key") unless query_params["api_key"] == API_KEY
  next render(status: 400, body: "No url specified") if url.empty?
  next render(status: 400, body: "Invalid url specified") unless valid_url?(url)

  set_kiosk_url(query_params["url"])
  next render(body: "ok")
end
