#!/bin/sh
# Automatically create users, databases and schemas for Rails 
psql -h postgres -U postgres -w -f .devcontainer/PG_Init_4_Rails.sql
psql -h postgres -U postgres -d rails_base_dev  -f .devcontainer/PG_Init_4_Rails_dev.sql
psql -h postgres -U postgres -d rails_base_test -f .devcontainer/PG_Init_4_Rails_test.sql
psql -h postgres -U postgres -d rails_base_prod -f .devcontainer/PG_Init_4_Rails_prod.sql
echo "Users, databases and schemas for Rails created!"