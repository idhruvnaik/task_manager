module RateLimit
  def self.limit(key:, limit:, period:)
    current = $redis.get(key)

    if current && current.to_i >= limit
      return false
    else
      $redis.multi do |multi|
        multi.incr(key)
        multi.expire(key, period)
      end

      return true
    end
  end
end
