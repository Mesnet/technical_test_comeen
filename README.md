Rails 7 API test
===

Objective
---

Develop an integration with a third-party device "deskq"
- Add a new integration type & its stored credentials (API key)
- When someone books a Desk, or the Desk booking period begins
  - use the new "deskq" integration to change the LED color of the device

Technical constraints
---

- Do not change the existing dependencies version (you may add new ones)
- Do not change the configured queue adapter

Instructions for handing in the test
---

* Fork the repository and make the necessary changes
* Commit your changes and provide the link to your repository when complete.

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
