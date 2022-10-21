# frozen_string_literal: true

class Configuration
  attr_accessor :api_key

  def initialize
    @api_key = "api_key_not_set"
  end
end
