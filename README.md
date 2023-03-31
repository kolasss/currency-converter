# Ruble exchange rates service

## Dependencies:

- ruby 3.2

For production we might use Redis or Memcached for caching, change `config.cache_store` in `config/environments/production.rb`.

## Usage

install and configure
```sh
bundle install
```

### Start app

start rails
```sh
bin/rails s
```

### Run in docker

edit docker-compose.yml if you want

```sh
docker compose build
docker compose up
```

### for development/test

run in docker
```sh
docker compose build
docker compose run --service-ports web bash
```

run tests
```sh
bin/rspec
```

run rubocop
```sh
bundle exec rubocop
```
