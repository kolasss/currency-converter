# NOTE: Don't forget to edit Dockerfile.production if needed
FROM ruby:3.2.2

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle config --global jobs `grep -c cores /proc/cpuinfo` && \
    bundle config --delete bin
RUN bundle install

COPY . .

EXPOSE 3000

# Start the main process.
CMD ["bin/rails", "s"]
