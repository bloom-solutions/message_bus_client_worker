class TestProc

  RANDOM = SecureRandom.uuid

  def self.call(data, _)
    REDIS.set(RANDOM, data.to_json)
  end

end
