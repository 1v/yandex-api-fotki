require 'rest-client'
require 'active_support/core_ext/hash/conversions'

require_relative 'fotki/version'
require_relative 'fotki/me'
require_relative 'fotki/albums'
require_relative 'fotki/album'
require_relative 'fotki/photos'
require_relative 'fotki/photo'

module Yandex
  module API
    module Fotki
      API_HOST = 'http://api-fotki.yandex.ru'
      class RuntimeError < RuntimeError ; end
      #
      # Main method for authentification
      #
      # @param [String] oauth_code OAuth code can be recieved here https://tech.yandex.ru/oauth/doc/dg/reference/web-client-docpage
      #
      # @return [Fotki]
      # @see https://tech.yandex.ru/oauth/doc/dg/reference/web-client-docpage/
      #
      def self.oauth(oauth_code)
        return self if !@api_urls.nil? && @oauth_code === oauth_code
        @oauth_code = oauth_code
        me = RestClient.get("#{API_HOST}/api/me/",
                             Fotki.oauth_hash)
        @api_urls = Me.new(me)
        self
      end
      #
      # Getter for instance variable
      #
      #
      # @return [String]
      #
      def self.oauth_code
        @oauth_code
      end
      #
      # OAuth header for RestClient
      #
      #
      # @return [Hash]
      #
      def self.oauth_hash
        { 'Authorization' => "OAuth #{Fotki.oauth_code}" }
      end
      #
      # User api urls
      #
      # @return [Fotki::Me]
      #
      def self.api_urls
        @api_urls
      end
      #
      # Fotki::Albums wrapper
      #
      # @return [Albums]
      #
      def self.albums
        Albums
      end
      #
      # Fotki::Photos wrapper
      #
      # @return [Fotki::Photos]
      #
      def self.photos
        Photos
      end
      #
      # XML parser wrapper. Because I'm not sure if it be persistent.
      #
      # @param [String] xml XML input
      #
      # @return [Hash] Hash
      #
      def self.xml_to_hash(xml)
        Hash.from_xml(xml)
      end
    end
  end
end
