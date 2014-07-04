require 'active_support/core_ext'
require 'net/http'
require 'uri'
require 'cgi'
require 'json'


def tally_user_count
  languages = %w(Ruby JavaScript Python Perl C PHP Java C# C++ Objective-C Shell)
  s = DateTime.new(2012,01,01)
  e = s.advance(months: 1)

  loop {
    break if DateTime.now.year == s.year and DateTime.now.month == s.month
    get_user_count(languages[0], format_datetime(s), format_datetime(e))
    s = e
    e = s.advance(months: 1)
    sleep 3
  }
end

def format_datetime(datetime)
  return datetime.strftime('%F')
end

def get_user_count(language, start_date, end_date) 
  created = CGI.escape("#{start_date}..#{end_date}")
  language = CGI.escape(language)

  puts('https://api.github.com/search/users?q=language:' + language + '+created:' + created)
  uri = URI.parse('https://api.github.com/search/users?q=language:' + language + '+created:' + created)
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
end

tally_user_count
