class TestProc

  RANDOM = SecureRandom.uuid

  def self.call(payload)
    REDIS.set(RANDOM, payload.to_json)
  end

end
