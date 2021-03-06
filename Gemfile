# source 'http://rubygems.org'
source :rubygems
source :rubyforge
source :gemcutter

# gem 'bundler', '~> 1.0.0'
# gem 'rails', '3.0.9'
gem 'rails', '3.1.0.rc5'

# gem 'rubytree', '0.5.2', :require => 'tree'
gem 'rubytree', '0.7.0'
# gem 'rack' , '~> 1.1.1'
# gem 'i18n', '>= 0.4.2'
gem 'coderay', '~> 0.9.7'

# gem 'ruby-prof', :git => 'http://github.com/wycats/ruby-prof.git'
gem 'ruby-prof'
# gem 'jquery-rails'
# gem 'prototype-rails'

group :development do
end

group :production do
end

group :test do
  gem 'test-unit'
  # gem 'shoulda', '~> 2.10.3'
  gem 'shoulda'
  gem 'mocha'
  gem 'edavis10-object_daddy', :require => 'object_daddy'

  platforms :mri_18 do gem 'ruby-debug' end
  platforms :mri_19 do gem 'ruby-debug19', :require => 'ruby-debug' end
end

group :openid do
  gem "ruby-openid", '~> 2.1.4', :require => 'openid'
end

group :rmagick do
  gem "rmagick", "~> 1.15.17"
end

# Use the commented pure ruby gems, if you have not the needed prerequisites on
# board to compile the native ones.  Note, that their use is discouraged, since
# their integration is propbably not that well tested and their are slower in
# orders of magnitude compared to their native counterparts. You have been
# warned.
#
platforms :mri do
  group :mysql do
    gem "mysql"
    #   gem "ruby-mysql"
  end

  group :mysql2 do
    gem "mysql2", "~> 0.2.7"
  end

  group :postgres do
    gem "pg", "~> 0.9.0"
    #   gem "postgres-pr"
  end
end

platforms :mri_18 do
  group :sqlite do
    # gem "sqlite3-ruby", "< 1.3", :require => "sqlite3"
    gem "sqlite3"
  end
end

platforms :mri_19 do
  group :sqlite do
    gem "sqlite3"
  end
end

platforms :mingw do
  group :mysql do
    gem "mysql"
    #   gem "ruby-mysql"
  end

  ## Add Windows support
  ## https://github.com/brianmario/mysql2/issues/8
  ## Getting mysql2 gem to work with Ruby on Rails 3.0 and Windows 7 64bit
  ## http://paul-wong-jr.blogspot.com/2011/06/getting-mysql2-gem-to-work-with-ruby-on.html
  # group :mysql2 do
  #   gem "mysql2", "~> 0.2.7"
  # end

  group :postgres do
    gem "pg", "~> 0.9.0"
    #   gem "postgres-pr"
  end

  group :sqlite do
    gem "sqlite3-ruby", "< 1.3", :require => "sqlite3"
    #   please tell me, if you are fond of a pure ruby sqlite3 binding
  end
end

platforms :jruby do
  gem "jruby-openssl"

  group :mysql do
    gem "activerecord-jdbcmysql-adapter"
  end

  group :postgres do
    gem "activerecord-jdbcpostgresql-adapter"
  end

  group :sqlite do
    gem "activerecord-jdbcsqlite3-adapter"
  end
end

# Load a "local" Gemfile
gemfile_local = File.join(File.dirname(__FILE__), "Gemfile.local")
if File.readable?(gemfile_local)
  puts "Loading #{gemfile_local} ..." if $DEBUG
  instance_eval(File.read(gemfile_local))
end

# Load plugins Gemfiles
Dir.glob(File.join(File.dirname(__FILE__), %w(vendor plugins * Gemfile))) do |file|
  puts "Loading #{file} ..." if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(file)
end
