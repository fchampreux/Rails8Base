-- Postgres PSQL script
-- Initialise users, databases and schemas for Ruby on Rails application development
-- Usage : psql -h postgres -U postgres -w -f .devcontainer/PG_Init_4_Rails.sql
-- Note : the .devcontainer/.pgpass contains posgtres user's password
--        each database is created by the postgres user in order not to define several users in the .pgpass
--        then they are assigned to the rails_user role. But:
--        It is strongly recommended to define dedicated users for each environment in order to avoid confusion.
--
-- Create users
CREATE USER rails_user NOSUPERUSER CREATEDB ENCRYPTED PASSWORD 'RailsApp';
--
-- Create databases 
CREATE DATABASE rails_base_dev OWNER postgres ENCODING UTF8 LC_COLLATE 'fr_FR.UTF8' LC_CTYPE 'fr_FR.UTF8' TEMPLATE template0;
GRANT ALL PRIVILEGES ON DATABASE rails_base_dev TO rails_user; 
CREATE DATABASE rails_base_test OWNER postgres ENCODING UTF8 LC_COLLATE 'fr_FR.UTF8' LC_CTYPE 'fr_FR.UTF8' TEMPLATE template0;
GRANT ALL PRIVILEGES ON DATABASE rails_base_test TO rails_user; 
CREATE DATABASE rails_base_prod OWNER postgres ENCODING UTF8 LC_COLLATE 'fr_FR.UTF8' LC_CTYPE 'fr_FR.UTF8' TEMPLATE template0;
GRANT ALL PRIVILEGES ON DATABASE rails_base_prod TO rails_user; 
--
