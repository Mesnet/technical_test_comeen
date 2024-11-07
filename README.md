Rails 7 API test
===

Repository presentation
---
## Core Functionality
The core functionality for this app revolves around managing desk bookings. The main components include:

### Models

* DeskBooking: Represents a booking for a specific start_datime and end_datetime of a desk by a user. It includes states like booked, canceled, checked_in, and checked_out using the aasm state machine.
* Desk: Represents a desk in the office space.
* User: Represents a user who can book desks. It uses Devise for authentication. A user has a timezone.

### Controllers

* DeskBookingsController: Manages CRUD operations for desk bookings, including actions like check_in and check_out.
* DesksController: Manages CRUD operations for desks.
* Users::ProfileController: Manages user profiles.

### Third-Party Integration

Integrations are managed through the following components:

#### Integration Models

* IntegrationGrant: Records that a user has granted access to an integration.
* Example: Google::DelegatedTokenCredentials: Handles OAuth2 credentials for Google Sheets integration.

#### Configuration

* integrations.yml: Stores integration configurations.
* application.rb: Loads integration configurations into the application.

### Testing
The project uses RSpec for testing, with comprehensive test coverage for models, controllers, and requests. Swagger is used for API documentation.


Objective
---

Develop an integration with a third-party device called **DeskQ**. 

A DeskQ is a physical device that shows the availability of desks in a shared office space. The device has an LED that can change color based on the availability of the desks.

![Desk Q photo](https://kenticoprod.azureedge.net/kenticoblob/crestron/media/crestron/generalsiteimages/blogs_2024/desk_q/photo1_desktop.png)

Each DeskQ device in the third-party API has a `desk_sync_id` field that corresponds to a Desk in our system. The DeskQ API provides a list of devices and the ability to change the LED color of a device for a specific DeskQ ID.

The API has the following endpoints:

- List DeskQ devices: GET https://671a10dfacf9aa94f6a8f596.mockapi.io/api/v1/deskq

- Change LED color of a DeskQ device: 
  - PUT https://671a10dfacf9aa94f6a8f596.mockapi.io/api/v1/deskq/:id 
  - params: { color: 'RED' } OR { color: 'GREEN' }

Authentication to this API is done via an API key that is passed in the headers of the request as a Bearer token.

You need to:
- Add a new integration type & its stored credentials (API key)
- use the new "deskq" integration to change the LED color of the device: 
  - When someone books a Desk for the current period (current time is between the start and end datetime)
  - When the period of a Desk booking created in advance is starting
  - When a desk booking is removed or checked out

> Make sure you take into account the timezone of the user when deciding to change the LED color or not.

Example:
* User A books a Desk for today from 10am to 12pm, and it's currently 11am in the user's timezone: LED color should change to RED. When it's 12pm, the LED color should change back to GREEN
* User B books a Desk for today from 10am to 12pm, and it's currently 9am in the user's timezone: LED color should not change. Then once it's 10am, the LED color should change to RED

Technical constraints
---

- Do not change the existing dependencies version (you may add new ones if needed)
- Do not change the configured queue adapter
- You can add new jobs and schedule
- Create tests for the new code

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
