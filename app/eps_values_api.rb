# frozen_string_literal: true

require_relative '../system/boot'
require 'goliath'

class EpsValuesApi < Goliath::API
  def response(env)
    [200, {}, "Hello world"]
  end
end
