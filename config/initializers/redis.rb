if Rails.env.development? or Rails.env.test?
  @path = 'redis://localhost:6379'
else 
  @path = ENV["REDISTOGO_URL"]
end 
  

##uri = URI.parse(ENV["REDISTOGO_URL"])
uri = URI.parse(@path)
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
##$redis = Redis.new(:host => 'localhost', :port => 6379)
##REDIS = Redis.connect(:url => ENV["REDISTOGO_URL"])
