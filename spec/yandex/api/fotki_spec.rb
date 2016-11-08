require "spec_helper"
# encoding: utf-8
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

    it { expect(Yandex::API::Fotki.oauth_code).to eql('AAAAAAA') }

    context '#api_urls' do
      it { expect(@fotki.api_urls.album).to \
        eql('http://api-fotki.yandex.ru/api/users/foobar/albums/') }
      it { expect(@fotki.api_urls.photo).to \
        eql('http://api-fotki.yandex.ru/api/users/foobar/photos/') }
      it { expect(@fotki.api_urls.tag).to \
        eql('http://api-fotki.yandex.ru/api/users/foobar/tags/') }
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
      it { expect(@album1[111111].id).to eql(111111) }
      it { expect(@album1[111111].title).to eql('site') }
      it { expect(@album1[222222].title).to eql('Неразобранное') }
      it { expect(@album1[111111].link['self']).to \
      eql('http://api-fotki.yandex.ru/api/users/foobar/album/111111/') }
      # cache testing
      it { expect(@album2[111111]).to be_nil }
      it { expect(@album2[333333].id).to eql(333333) }
    end

    context '#photos' do
      before do
        allow(RestClient).to receive(:post).and_return \
          fixture('fotki/photos-upload.xml')
      end
      let(:photo) { @fotki.photos.upload(:image => '') }
      it { expect{ @fotki.photos.upload(:access => 'private') }.to \
      raise_error(RuntimeError, ':image is required') }
      it { expect(photo.links['orig']['href']).to \
        eql('http://img-fotki.yandex.ru/get/12345/123456789.0/0_123456_12345678_orig') }
      it { expect(@fotki.photos.upload(:image => '', :album => 123456))\
            .to be_a Yandex::API::Fotki::Photo }
    end
  end
end
