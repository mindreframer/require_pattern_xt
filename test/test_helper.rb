require 'bundler'
Bundler.setup
require "maxitest/autorun"
require "mocha/mini_test"

require_relative '../lib/require_pattern_xt'
Dir.chdir File.expand_path('../dummy', __FILE__)
