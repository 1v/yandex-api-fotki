require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "yandex/api/fotki"

RSpec.configure do |config|
  def fixture(filename)
    # puts "#{filename}: read action"
    open(File.dirname(__FILE__) + '/fixtures/' + filename, "r:UTF-8").read
  end
end
