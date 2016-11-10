module Yandex
  module API
    module Fotki
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
    end
  end
end
