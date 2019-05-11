# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'envied'

$LOAD_PATH.unshift(File.expand_path('../app', __dir__))

ENV['RACK_ENV'] ||= 'production'
ENVied.require

require_relative 'logging'
