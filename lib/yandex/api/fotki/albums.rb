module Yandex
  module API
    module Fotki
      class Albums
        #
        # List user albums
        #
        # @param [Hash] options
        # @option options [String] sort updated or rupdated or published or rpublished
        # @option options [Integer] offset Not implemented
        # @option options [Integer] limit 100 is max
        #
        # @return [Hash] Hash of Fotki::Album were keys is id of album
        # @see https://tech.yandex.ru/fotki/doc/operations-ref/albums-collection-get-docpage/
        #
        def self.list(options = {})
          options[:sort] ||= 'updated'
          options[:offset] ||= 0
          options[:limit] ||= 10

          return @list_cache if !@list_cache.nil? && options === @list_options_cache

          @list_options_cache = options

          list = RestClient.get("#{Fotki.api_urls.album}#{options[:sort]}/?limit=#{options[:limit]}", Fotki.oauth_hash)

          @list_cache = Fotki.xml_to_hash(list)['feed']['entry']
          @list_cache = @list_cache.map { |i|
            album = Album.new(i)
            { album.id => album }
          }.inject(:merge)
        end
      end
    end
  end
end
