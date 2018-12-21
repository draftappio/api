FROM ruby:latest
MAINTAINER Islam Wazery <wazery@ubuntu.com>

ENV HOME /home/rails/api

# Install dependencies and js engine
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

WORKDIR $HOME

# Install gems
ADD Gemfile* $HOME/

RUN DISABLE_SSL=true gem install puma -v '3.6.0' -- --with-opt-dir=/usr/local

RUN bundle install

# Add the app code
ADD . $HOME

# Default command
ENTRYPOINT ["bundle", "exec"]
CMD RAILS_ENV=production bundle exec rake db:setup && bundle exec rake db::migrate
CMD ["rails", "server", "--binding", "0.0.0.0", "-e", "production"]
