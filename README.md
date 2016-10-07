# Yandex::Api::Fotki

API wrapper for Yandex Fotki

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yandex-api-fotki'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yandex-api-fotki

## Usage
Инструкция как получить OAUTH_CODE https://tech.yandex.ru/oauth/doc/dg/tasks/get-oauth-token-docpage/
```ruby
fotki = Yandex::API::Fotki.oauth(OAUTH_CODE)
photo = fotki.photos.upload(:image => File.new('/file.png'),
                            :access => 'private',
                            :album => 123456,
                            :title => "My Image")
orig = photo.links['orig']['href']
=> http://img-fotki.yandex.ru/get/117982/392595458.57fe/0_26753c_713f7b6a_orig
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

