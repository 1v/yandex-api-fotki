require 'rest-client'
require 'active_support/core_ext/hash/conversions'

require "yandex/api/fotki/version"

module Yandex
  module API
    module Fotki
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
        return self unless @api_urls.nil?
        @oauth_code = oauth_code
        me = RestClient.get('http://api-fotki.yandex.ru/api/me/',
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
        { 'Authorization': "OAuth #{Fotki.oauth_code}" }
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
      # Class Me is wrapper for user service document
      #
      # @see https://tech.yandex.ru/fotki/doc/operations-ref/service-document-get-docpage/
      #
      class Me
        attr_reader :album, :photo, :tag
        #
        # Parse response from Fotki.oauth
        #
        # @param [RestClient::Response] response
        #
        def initialize(response)
          # Nokogiri::XML(me).xpath("/app:service/app:workspace/app:collection[@id='album-list']/@href").text
          collention = Fotki.xml_to_hash(response)['service']['workspace']['collection'].map{ |i| { i['id'] => i['href'] }}.inject(:merge)
          @album = collention['album-list']
          @photo = collention['photo-list']
          @tag = collention['tag-list']
        end
      end
      #
      # Class Albums is wrapper for albums listing
      #
      class Albums
        #
        # List user albums
        #
        # @param [Hash] hash
        # @option hash [String] sort updated or rupdated or published or rpublished
        # @option hash [Integer] offset Not implemented
        # @option hash [Integer] limit 100 is max
        #
        # @return [Hash] Hash of Fotki::Album were keys is id of album
        # @see https://tech.yandex.ru/fotki/doc/operations-ref/albums-collection-get-docpage/
        #
        def self.list(hash = { :sort => 'updated', :offset => 0, :limit => 10 })
          return @list_cache unless @list_cache.nil?

          list = RestClient.get("#{Fotki.api_urls.album}#{hash[:sort]}/?limit=#{hash[:limit]}", Fotki.oauth_hash)

          @list_cache = Fotki.xml_to_hash(list)['feed']['entry']
          @list_cache = @list_cache.map { |i|
            album = Album.new(i)
            { album.id => album }
          }.inject(:merge)
        end
      end
      #
      # Class Album is wrapper for single album
      #
      class Album
        attr_reader :id, :title, :link
        #
        # <description>
        #
        # @param [Hash] hash Hash from {Fotki::Albums.list} response
        #
        def initialize(hash)
          @id = parse_id(hash['id'])
          @title = hash['title']
          @link = hash['link'].map{ |i| { i['rel'] => i['href'] } }.inject(:merge)
        end

        private
          def parse_id(string)
            string.split(':').last.to_i
          end
      end

      #
      # Class Photos provides photos collections
      #
      class Photos
        #
        # Uploading photo
        #
        # @param [Hash] hash
        #
        # == Required
        # @option hash [File] :image IO stream of file. For example +File.new('tmp/file.png')+ or +open('\h\ttp://site.com/image.png')+
        # == Optional
        # @option hash [String] :title Title of image
        # @option hash [String] :summary Description of image
        # @option hash [Integer] :album Id of album to upload
        # @option hash [String] :access public, friends or private
        # @see https://tech.yandex.ru/fotki/doc/concepts/add-photo-docpage/#multipart-format
        #
        # @return [Fotki::Photo] Instance of Photo class
        #
        def self.upload(hash)
          raise Fotki::RuntimeError, ':image is required' unless hash[:image]
          response = RestClient.post(Fotki.api_urls.photo, hash, Fotki.oauth_hash)
          Photo.new(response)
        end
      end
      #
      # Class Photo is wrapper for single photo
      #
      # @see https://tech.yandex.ru/fotki/doc/operations-ref/photo-get-docpage/
      #
      class Photo
        attr_reader :id, :links
        #
        # Photo initialize
        #
        # @param [RestClient::Response] response
        #
        def initialize(response)
          entry = Fotki.xml_to_hash(response)['entry']
          @id = entry['id'].split(':').last.to_i
          @links = entry['img'].map{ |i| { i['size'] => i } }.inject(:merge)
          # puts JSON.pretty_generate(entry)
        end
      end

      private
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
