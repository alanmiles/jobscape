#$redis = Redis.new(:host => 'localhost', :port => 6379)
#REDIS = Redis.connect(:url => ENV["REDISTOGO_URL"])
uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

