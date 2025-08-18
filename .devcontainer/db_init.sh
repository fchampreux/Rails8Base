#!/bin/sh
# Automatically create users, databases and schemas for Rails Dev and Test environments
# Sample: psql -h postgres -U postgres -w -f .devcontainer/PG_Init_4_Rails.sql
psql  -U postgres -w -f PG_Init_4_Rails.sql
psql  -U rails_user -d rails_base_dev  -f PG_Init_4_Rails_dev.sql
psql  -U rails_user -d rails_base_test -f PG_Init_4_Rails_test.sql
echo "Users, databases and schemas for Rails created!"