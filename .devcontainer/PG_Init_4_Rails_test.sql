-- Create schemas
CREATE SCHEMA IF NOT EXISTS rails_app AUTHORIZATION rails_user;
-- Change database owner
ALTER DATABASE rails_base_test OWNER TO rails_user;