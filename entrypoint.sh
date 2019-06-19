#!/bin/sh
# If the secrets file exists, read it in.
if [ -f secrets.sh ]; then
  . /app/secrets.sh
fi

bundle exec rackup --host 0.0.0.0 -p 8002

# Now run the main container CMD, replacing this script.
exec "$@"
