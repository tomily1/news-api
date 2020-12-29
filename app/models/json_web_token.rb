# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = ENV['JWT_SECRET']
  ALGORITHM = 'HS512'

  def self.encode(payload)
    # Issued by
    payload[:iss] ||= 'news-api'
    # Issued at
    payload[:iat] ||= Time.now.to_i
    # Not valid before
    payload[:nbf] ||= Time.now.to_i

    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: ALGORITHM)[0]
    HashWithIndifferentAccess.new decoded
  end
end
