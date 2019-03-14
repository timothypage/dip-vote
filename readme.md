# Dip Vote

an app to facilitate voting on dips

## Setup

    bundle install
    bundle exec sequel -m db/migrations sqlite://db/app_development.db
    ruby server.rb

for production set some environment variables

    SESSION_SECRET
    TOKEN_SIGNING_SECRET

they will default to some random value if not set, so your login tokens will be useless between server restarts
