#!/bin/bash
set -e

bundle exec rails db:prepare
bundle exec rails db:seed
bundle exec rails taxi:seed_content

exec "$@"
