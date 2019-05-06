require_relative '../vendors/hash'
require_relative './default_rest_module.rb'
require 'json'
require 'uri'
require 'rest-client'
require 'multi_json'

class DefaultRest
  extend ApiTools::DefaultRestModule
end
