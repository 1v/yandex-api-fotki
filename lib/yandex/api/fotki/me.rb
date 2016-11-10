module Yandex
  module API
    module Fotki
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
    end
  end
end
