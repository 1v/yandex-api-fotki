# encoding: utf-8
require "spec_helper"

describe Yandex::API::Fotki do
  describe 'Yandex::API::Fotki' do
    context '#photos' do
      before do
        allow(RestClient).to receive(:get)\
          .with('http://api-fotki.yandex.ru/api/me/', any_args)\
          .and_return(fixture('fotki/me.xml'))
        # allow(RestClient).to receive(:get).and_call_original
        @fotki = Yandex::API::Fotki.oauth('AAAAAAA')
      end

      context '#get' do
        before do
          allow(RestClient).to receive(:get)\
            .with('http://api-fotki.yandex.ru/api/users/user/photo/123456/', any_args)\
            .and_return(fixture('fotki/photo.xml'))
        end

        it do
          expect{ @fotki.photos.get(user: 'user') }.to\
            raise_error(RuntimeError, ':id is required')
        end

        it do
          expect{ @fotki.photos.get(id: 123456) }.to \
            raise_error(RuntimeError, ':user is required')
        end

        it do
          expect(@fotki.photos.get(user: 'user', id: 123456).id).to eql(1234567)
        end
      end

      context '#upload' do
        before do
          allow(RestClient).to receive(:post).and_return \
            fixture('fotki/photos-upload.xml')
        end

        let(:photo) { @fotki.photos.upload(:image => '') }

        it do
          expect{ @fotki.photos.upload(:access => 'private') }.to \
            raise_error(RuntimeError, ':image is required')
        end

        it do
          expect(photo.links['orig']['href']).to \
            eql('http://img-fotki.yandex.ru/get/12345/123456789.0/0_123456_12345678_orig')
        end

        it do
          expect(@fotki.photos.upload(:image => '', :album => 123456)).to \
            be_a Yandex::API::Fotki::Photo
        end
      end
    end
  end
end
