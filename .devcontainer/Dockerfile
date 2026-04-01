# CodeSandbox supports debian & ubuntu based images
FROM ruby:4-trixie

ENV RAILS_DEVELOPMENT_HOSTS=".csb.app"

# Adding the PostgreSQL repository so we can install postgresql-client
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt trixie-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/postgresql.gpg
# Install postgresql-client
RUN apt-get update && apt-get install -y postgresql-client