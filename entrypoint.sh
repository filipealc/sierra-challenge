#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Wait for the database to start
echo "Waiting for database to start..."
sleep 10

# Run database migrations
echo "Running database migrations..."
bundle exec rake db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"