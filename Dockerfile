# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.1
FROM ruby:$RUBY_VERSION-alpine

# Install base packages
RUN apk add --update --no-cache \
    build-base

# Application lives here
WORKDIR /app

# Copy application code
COPY . .

RUN bundle install
