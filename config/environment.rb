# Load the rails application
require File.expand_path('../application', __FILE__)

if RUBY_VERSION >= '1.9'
  Encoding.default_external = 'UTF-8'
end

# Initialize the rails application
Redmine::Application.initialize!

