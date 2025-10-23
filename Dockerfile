
FROM ruby:3.2.4-slim-bookworm AS base

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    postgresql-client \
    curl \
    nodejs \
    yarn \
    && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8
ENV BUNDLE_JOBS 4
ENV BUNDLE_RETRY 3

COPY Gemfile Gemfile.lock* ./

RUN gem install bundler

RUN bundle install

FROM base AS development

COPY ./docker-entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]