require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'simplecov'
SimpleCov.start

require_relative 'test_alliance_setup.rb'
require_relative 'test_alliance_bets.rb'