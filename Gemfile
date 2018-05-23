# Gemfile
#
# For production mode PostgreSQL option :
#   bundle install --without development test mysql sqlite
# For production mode MySQL option :
#   bundle install --without development test postgresql sqlite
#
# Make sure to declare at least one 'source'
source 'https://rubygems.org'

# Bundler requires these gems in all environments
gem 'rails', '~> 4.2.0'

# Models and database interactions
gem 'activerecord-import'
gem 'arel', '~>6.0.2'
gem 'pluck_to_hash'
gem 'upsert'

# CSS and JavaScript
gem 'autoprefixer-rails'
gem 'js-routes'
gem 'jquery-rails'
gem 'libv8'
gem 'sass-rails',   '5.0.0.beta1'
gem 'uglifier',     '>= 1.3.0'
gem 'webpacker', '~> 3.0'

# Background tasks
gem 'activejob-status', git: 'https://github.com/inkstak/activejob-status.git'
gem 'resque'
gem 'redis-rails'

# Authorization
gem 'pundit'

# Statistics
gem 'descriptive_statistics', '~> 2.5', :require => 'descriptive_statistics/safe'
gem 'histogram', '~> 0.2.4.1'

# Internationalization
gem 'i18n'
gem 'i18n-js'
gem 'rails-i18n', '~> 4.0'

# Exam template requirements
gem 'combine_pdf'
gem 'prawn'
gem 'prawn-qrcode'
gem 'rmagick'
gem 'zxing_cpp'

# Ruby miscellany
gem 'json'
gem 'net-ssh'
gem 'redcarpet'
gem 'rubyzip'
gem 'rugged'
gem 'ya2yaml'

# Rails miscellany
gem 'activerecord-session_store', '~>0.1.0'
gem 'responders', '~> 2.0'
gem 'rails-html-sanitizer'

# If you are a MarkUs developer and use PostgreSQL, make sure you have
# PostgreSQL header files installed (e.g. libpq-dev on Debian/Ubuntu).
# Then install your bundle by:
#   bundle install --without mysql sqlite
group :postgresql do
  gem 'pg', '~> 0.21'  # TODO: upgrade only when using Rails 5.1.5+
end

# If you are a MarkUs developer and use MySQL, make sure you have
# MySQL header files installed (e.g. libmysqlclient-dev on Debian/Ubuntu).
# Then install your bundle by:
#   bundle install --without postgresql sqlite
group :mysql do
  gem 'mysql2'
end

# If you are a MarkUs developer and use SQLite, make sure you have
# SQLite header files installed (e.g. libsqlite3-dev on Debian/Ubuntu).
# Then install your bundle by:
#   bundle install --without postgresql mysql
group :sqlite do
  gem 'sqlite3'
end

# Gems only used for development should be listed here so that they
# are not loaded in other environments.
group :development do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller' , '>= 0.8'  # supplement for better_errors
  gem 'quiet_assets' # TODO: remove when upgrade to sprockets 3
  gem 'bullet'
end

group :test do
  gem 'factory_girl_rails'
  gem 'machinist', '< 2'
  gem 'minitest'
  gem 'mocha', require: false
  gem 'shoulda'
  gem 'simplecov'
  gem 'time-warp'
  gem 'database_cleaner'
  gem 'shoulda-callback-matchers', '~> 1.1.1'
  gem 'rails-controller-testing'
  gem 'rails-perftest'
end

# Gems needed (wanted) for both development and test can be
# listed here
group :development, :test do
  gem 'byebug'
  gem "rspec-rails", '~> 3.5'
end

# Gems needed (wanted) for development, test and production_test
# can be listed here
# production_test is for testing a production-like deployment,
# but using a seeded database
group :development, :test, :production_test do
  gem 'faker' # required for database seeding
end

# Gems not needed at runtime should go here so that MarkUs does
# not waste time/memory loading them during boot
group :offline do
  gem 'railroady'
  gem 'rdoc'
  gem 'rubocop'
  gem 'rubocop-git'
end

# If you  plan to use unicorn servers for production
# make sure that this group is included. You don't need this
# group if you are using Phusion Passenger.
group :unicorn do
  gem 'unicorn'
end
