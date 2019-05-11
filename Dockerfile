From ruby:2.6.3-alpine

RUN apk update && apk --no-cache add gcc make g++

ENV APP_HOME /app
WORKDIR $APP_HOME
EXPOSE 80

CMD ["bin/run"]

RUN gem update bundler

COPY Gemfile Gemfile.lock $APP_HOME/

RUN bundle install --jobs 6 --retry 2

COPY . $APP_HOME/
