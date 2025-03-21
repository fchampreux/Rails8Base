# README

This repository proposes a base to automatically implement a Rails 8/Postgres container.

## Technical specifications
Please check the .devcontainer/Dockerfile and .devcontainer/docker-compose.yml to discover the base containers.
 - Ruby 3.4.2
 - Rails 8.0.2
 - PostgreSQL 16
 - db_init.sh script creates dev/test/prod databases
 - .pgpass contains the credentials used by the db_init.sh script

## Setup
 - Create your own repository from the Rails8Base template
 - Create a Codesandbox container from your Github repository
 - Note that the setup task modifies the security of the .devcontainer/.pgpass file, which triggers a container's configuration update notification. You can ignore it for now.
 - Define a system variable for this repository: PGPASSFILE=/.devcontainer/.pgpass
 - Run the db_init.sh script => databases are persisted
 - Generate the master.key file and crypted credentials for Rails : (credentials.yml.enc must not be present at this time)
   
   *EDITOR="nano" bin/rails credentials:edit*
   
   Add the following:
   ```
   database:
   
      password: <your_password as defined in .devcontainer/PG_Init_4_Rails.sql>
   
      schema: rails_app
   ```

Further reboots should automatically start the Rails 8 website, visible on port 80 from your web browser.

