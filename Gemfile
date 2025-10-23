source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# Autenticação
gem "devise", "~> 4.9.0"
gem "devise-jwt", "~> 0.9.0"
gem "bcrypt", "~> 3.1.7"

# Autorização
gem "pundit", "~> 2.3.0"

# Serialização
gem "fast_jsonapi", "~> 1.5"

# Paginação
gem "kaminari", "~> 1.2.0"

# HTTP Requests
gem "httparty", "~> 0.21.0"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development, :test do
  gem 'rspec-rails', '~> 6.0'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.2'
  gem 'shoulda-matchers', '~> 5.3'
end

gem "rswag", "~> 2.16"

gem "graphql", "~> 2.5"

gem "graphiql-rails", "~> 1.10"
