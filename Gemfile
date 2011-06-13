source :rubygems
source :rubyforge
source :gemcutter

gem 'bundler', '~> 1.0.0'
gem 'rails', '2.3.11'
gem 'rack' , '~> 1.1.1'
gem 'i18n', '>= 0.4.2'
gem 'rubytree', '0.5.2', :require => 'tree'
gem 'coderay', '~> 0.9.7'

# Please uncomment lines for your databases.
# Alternatively you may want to add these lines to specific groups below.
# gem 'sqlite3-ruby', :require => 'sqlite3'  # for SQLite 3
# gem 'mysql'                                #     MySQL
# gem 'pg'                                   #     PostgreSQL
gem 'pg'

group :development do
end

group :production do
end

group :test do
  gem 'shoulda'
  gem 'mocha'
  gem 'edavis10-object_daddy', :require => 'object_daddy'
end

# Load plugins Gemfiles
Dir.glob(File.join(File.dirname(__FILE__), %w(vendor plugins * Gemfile))) do |file|
  puts "Loading #{file} ..."
  instance_eval File.read(file)
end
