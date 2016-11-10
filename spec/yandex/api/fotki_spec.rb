# encoding: utf-8
require "spec_helper"

describe Yandex::API::Fotki do
  it "has a version number" do
    expect(Yandex::API::Fotki::VERSION).not_to be nil
  end

  before do
    allow(RestClient).to receive(:get)\
      .with('http://api-fotki.yandex.ru/api/me/', any_args)\
      .and_return(fixture('fotki/me.xml'))
    # allow(RestClient).to receive(:get).and_call_original
    @fotki = Yandex::API::Fotki.oauth('AAAAAAA')
  end

  describe 'Yandex::API::Fotki' do
    context '#oauth' do
      it do
        expect(Yandex::API::Fotki.oauth_code).to eql('AAAAAAA')
      end

      it 'test API key change' do
        @fotki_temp = Yandex::API::Fotki.oauth('BBBBBB')
        expect(Yandex::API::Fotki.oauth_code).to eql('BBBBBB')
      end
    end

    context '#api_urls' do
      it do
        expect(@fotki.api_urls.album).to \
          eql('http://api-fotki.yandex.ru/api/users/foobar/albums/')
      end

      it do
        expect(@fotki.api_urls.photo).to \
          eql('http://api-fotki.yandex.ru/api/users/foobar/photos/')
      end

      it do
        expect(@fotki.api_urls.tag).to \
          eql('http://api-fotki.yandex.ru/api/users/foobar/tags/')
      end
    end

    context '#albums' do
      before do
        allow(RestClient).to receive(:get)\
          .with("http://api-fotki.yandex.ru/api/users/foobar/albums/updated/?limit=10", any_args)\
          .and_return(fixture('fotki/albums-list.xml'))
          @album1 = @fotki.albums.list(sort: 'updated')
        allow(RestClient).to receive(:get)\
          .with("http://api-fotki.yandex.ru/api/users/foobar/albums/published/?limit=10", any_args)\
          .and_return(fixture('fotki/albums-list-2.xml'))
          @album2 = @fotki.albums.list(sort: 'published')
      end

      it do
        expect(@album1[111111].id).to eql(111111)
      end

      it do
        expect(@album1[111111].title).to eql('site')
      end

      it do
        expect(@album1[222222].title).to eql('Неразобранное')
      end

      it do
        expect(@album1[111111].link['self']).to \
      eql('http://api-fotki.yandex.ru/api/users/foobar/album/111111/')
      end
      # cache testing
      it do
        expect(@album2[111111]).to be_nil
      end

      it do
        expect(@album2[333333].id).to eql(333333)
      end
    end
  end
end
