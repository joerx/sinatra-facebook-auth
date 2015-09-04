Facebook based authentication demo using Sinatra.

## Prerequisites

Ruby (used 2.2 on my box), bundler

## Setup & Running

`bundle install`, `rackup`

## Browser

- Install gems via bundler, then `rackup` to start the dev server. 
- Open browser on `localhost:9292`
- Log in with your Facebook account

## API

Get a valid Facebook access token, e.g. via [Graph API Explorer](https://developers.facebook.com/tools/explorer/), then:

```
GET http://localhost:9292/token
Authorization: Facebook $(valid_facebook_access_token)
```

## Disclaimer & License

Not responsible for your kitten getting eaten by a Velociraptor, nor for any other damage. 

License: ISC
