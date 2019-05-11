# frozen_string_literal: true

require 'logger'

LOGGER = ENV['RACK_ENV'] == 'test' ? Logger.new('/dev/null') : Logger.new(STDOUT)
