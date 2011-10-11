#$redis = Redis.new(:host => 'localhost', :port => 6379)
REDIS = Redis.connect(:url => ENV["REDISTOGO_URL"])

