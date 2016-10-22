# Yandex::Api::Fotki

[![Gem Version](https://badge.fury.io/rb/yandex-api-fotki.svg)](https://rubygems.org/gems/yandex-api-fotki)
[![Build Status](https://travis-ci.org/1v/yandex-api-fotki.svg?branch=master)](https://travis-ci.org/1v/yandex-api-fotki)
[![Dependency Status](https://gemnasium.com/badges/github.com/1v/yandex-api-fotki.svg)](https://gemnasium.com/github.com/1v/yandex-api-fotki)
[![Code Climate](https://codeclimate.com/github/1v/yandex-api-fotki/badges/gpa.svg)](https://codeclimate.com/github/1v/yandex-api-fotki)
[![Test Coverage](https://codeclimate.com/github/1v/yandex-api-fotki/badges/coverage.svg)](https://codeclimate.com/github/1v/yandex-api-fotki/coverage)

API wrapper for Yandex Fotki

## Requirements

* Ruby >= 2.0.0 (create [new issue](https://github.com/1v/yandex-api-fotki/issues/new) if you need 1.9.3)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yandex-api-fotki'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yandex-api-fotki
    
And require:
```ruby
require 'yandex-api-fotki'
```

## Usage
Instruction how to get OAUTH_CODE [`tech.yandex.ru`](https://tech.yandex.ru/oauth/doc/dg/tasks/get-oauth-token-docpage/)
```ruby
fotki = Yandex::API::Fotki.oauth(OAUTH_CODE)
photo = fotki.photos.upload(:image => File.new('/file.png'),
                            :access => 'private',
                            :album => 123456,
                            :title => "My Image")
photo.id
=> 123456
photo.links
=> {
     "XXS" => {
        "height" => "75",
          "href" => "http://img-fotki.yandex.ru/get/123456/123456468.56be/0_123bcc_ad08a9de_XXS",
          "size" => "XXS",
         "width" => "75"
    },
...
    "orig" => {
        "bytesize" => "0",
          "height" => "237",
            "href" => "http://img-fotki.yandex.ru/get/123456/123456468.56be/0_1234bcc_ad08a9de_orig",
            "size" => "orig",
           "width" => "200"
    }
}
```
All available options: [`tech.yandex.ru`](https://tech.yandex.ru/fotki/doc/concepts/add-photo-docpage/#multipart-format)

## Documentation

[`www.rubydoc.info`](http://www.rubydoc.info/github/1v/yandex-api-fotki/)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

