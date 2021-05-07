# frozen_string_literal: true

class JsonTestApp
  attr_accessor :hash

  def initialize(hash)
    @hash = hash
  end

  def call(_env)
    [
      200,
      {
        'Content-Type' => 'application/json',
        'Content-Length' => hash.to_json.bytesize.to_s
      },
      [hash.to_json]
    ]
  end
end
