FROM node:16.20.2-alpine AS node

FROM ruby:3.1.2-alpine

ARG BUNDLER_VERSION=2.6.7

ENV BUNDLE_WITHOUT=production \
    RUBYOPT=-rlogger

RUN apk add --no-cache build-base sqlite-dev tzdata

COPY --from=node /usr/local /usr/local
RUN npm install --global --force yarn@1.22.22

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v "${BUNDLER_VERSION}" \
    && bundle install

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
