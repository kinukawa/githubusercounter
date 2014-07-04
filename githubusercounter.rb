require 'net/http'
require 'uri'
require 'json'

uri = URI.parse('https://api.github.com/search/users?q=language:Objective-C+created:2009-08-18')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
res = http.start {
  http.get(uri.request_uri)
}

if res.code == '200'
  result = JSON.parse res.body
  puts result['total_count']
else
  puts "failed. status code:#{res.code} #{res.message}"
end
