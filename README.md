# aliases-web-management

Small web client for managing the /etc/aliases file.

## Running the app

You can run the manager in one of two ways
 1. Using `rackup` provided by [Rack](https://github.com/rack/rack)
 2. Or with Apache and Phusion Passenger, pointing Passenger to the `public` directory.

## Securing the app

The client does not employ any of its own authentication systems.

It is strongly recommended that you place the web app either behind IP restrictions, or an appropriately secure HTTP Basic/Digest Auth system.
