module Yandex
  module API
    module Fotki
      class Photos
        #
        # Uploading photo
        #
        # @param [Hash] options
        #
        # == Required
        # @option options [File] :image IO stream of file. For example +File.new('tmp/file.png')+ or +open('\h\ttp://site.com/image.png')+
        # == Optional
        # @option options [String] :title Title of image
        # @option options [String] :summary Description of image
        # @option options [Integer] :album Id of album to upload
        # @option options [String] :access public, friends or private
        # @see https://tech.yandex.ru/fotki/doc/concepts/add-photo-docpage/#multipart-format
        #
        # @return [Fotki::Photo] Instance of Photo class
        #
        def self.upload(options)
          raise Fotki::RuntimeError, ':image is required' unless options[:image]
          response = RestClient.post(Fotki.api_urls.photo, options, Fotki.oauth_hash)
          Photo.new(response)
        end
        #
        # Get info about photo
        #
        # @param [Hash] options
        #
        # == Required
        # @option options [String] :user Owner of photo
        # @option options [String] :id Photo id
        #
        # @return [Fotki::Photo] Instance of Photo class
        #
        def self.get(options)
          raise Fotki::RuntimeError, ':user is required' unless options[:user]
          raise Fotki::RuntimeError, ':id is required' unless options[:id]
          url = "#{API_HOST}/api/users/#{options[:user]}/photo/#{options[:id].to_s}/"
          headers = options.except(:user, :id).merge(Fotki.oauth_hash)
          response = RestClient.get(url, headers)
          Photo.new(response)
        end
      end
    end
  end
end
