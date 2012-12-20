# aliases-web-management

Small web client for managing the `/etc/aliases` file.

## Configuring the app

 1. Create a config file at `config/config.yml` based on the example file in the same directory.
 2. Place lines with `#%%%` at their beginning at the start and end of the part of the aliases file you wish to manage with the web tool.
 3. You should `chgrp` your `/etc/aliases` file so that it is accessible by the group that your webserver will run as (usually `www-data`) and make sure the file is `chown`'d with `rw-rw-r--` permissions.
 4. Ensure the aliases file does not have any recursive references, or pipe to other applications in the managed sections.
 5. Also ensure that the file does not reference in the destination any aliases not defined in the managed section.

## Securing the app

The client does not employ any of its own authentication systems.

It is strongly recommended that you place the web app either behind IP restrictions, or an appropriately secure HTTP
Basic/Digest Auth system.

## Running the app

You can run the manager in one of two ways
 1. Using `rackup` provided by [Rack](https://github.com/rack/rack)
 2. Or with Apache and Phusion Passenger, pointing Passenger to the `public` directory.