Rails 7 API test
===

Objective
---

Develop an integration with a third-party device "deskq"
- Add a new integration type & its stored credentials (API key)
- When someone books a Desk, or the Desk booking period begins, use the new "deskq" to change the LED color of the device


Requirements
---
- Ruby 3.2.2
- Redis
- bundler

Development
---

Make your own env file
```sh
cp .env.example .env.development.local
```
Install dependencies
```sh
bundle install
```
Setup database & seed it with initial data
```
bundle exec rails db:setup
```
Run the server and jobs worker
```
foreman start
```
