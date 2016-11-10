module Yandex
  module API
    module Fotki
      class Album
        attr_reader :id, :title, :link
        #
        # <description>
        #
        # @param [Hash] options Hash from {Fotki::Albums.list} response
        #
        def initialize(options)
          @id = parse_id(options['id'])
          @title = options['title']
          @link = options['link'].map{ |i| { i['rel'] => i['href'] } }.inject(:merge)
        end

        private
          def parse_id(string)
            string.split(':').last.to_i
          end
      end
    end
  end
end
