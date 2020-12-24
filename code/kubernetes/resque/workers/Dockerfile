FROM ruby:2.6-alpine

RUN gem install bundler -v 2.2.3

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENV QUEUE *

ENTRYPOINT ["bundle", "exec", "rake"]
CMD ["resque:work"]
