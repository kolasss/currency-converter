# NOTE: Don't forget to edit Dockerfile.production if needed
FROM ruby:3.2.2

# ENV LANG=C.UTF-8

# RUN echo "gem: --no-document" > $HOME/.gemrc && \
#     touch $HOME/.irb-history && \
#     echo "IRB.conf[:SAVE_HISTORY] = 1000\nIRB.conf[:HISTORY_FILE] = '~/.irb-history'" > $HOME/.irbrc

RUN mkdir /app
WORKDIR /app

# Upgrade RubyGems and install latest Bundler
# RUN gem update --system && \
#     gem install bundler -v 2.4.8

COPY Gemfile Gemfile.lock ./
RUN bundle config --global jobs `grep -c cores /proc/cpuinfo` && \
    bundle config --delete bin
RUN bundle install

COPY . .

EXPOSE 3000

# Start the main process.
CMD ["bin/run.sh"]
