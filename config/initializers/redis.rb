$redis = Redis::Namespace.new("instabugchattingsystem",:redis => Redis.new(host: ENV["REDIS_HOST"]))