# sinatra-facebook-auth

Facebook based authentication demo using sinatra.rb

## Setup & Running

`bundle install`, `rackup`

## Authentication

Get a valid Facebook access token, e.g. via [Graph API Explorer](https://developers.facebook.com/tools/explorer/), then:

```
GET http://localhost:9292/token
Authorization: Facebook $(valid_facebook_access_token)
```
