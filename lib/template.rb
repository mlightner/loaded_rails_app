require "monkey_patch_for_ask_bug"

def newpass( len )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
end

# Set up git repository
git :init

# Set up .gitignore files
run %{find . -type d -empty | xargs -I xxx touch xxx/.gitignore}
file '.gitignore', <<-END
.DS_Store
coverage/*
log/*.log
db/*.db
db/*.sqlite3
db/schema.rb
tmp/**/*
doc/api
doc/app
config/database.yml
coverage/*
END

# Initialize submodules
git :submodule => "init"

# Create migration for users table
file 'db/migrate/0_create_users.rb', <<-CODE
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.timestamps
      t.string :login, :null => false
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false
      t.integer :login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip
    end
    
    add_index :users, :login
    add_index :users, :persistence_token
    add_index :users, :last_request_at
  end

  def self.down
    drop_table :users
  end
end
CODE


# Create migration for enumerations_mixin
file 'db/migrate/1_virtual_enumerations.rb', <<-CODE
class VirtualEnumerations < ActiveRecord::Migration
  def self.up
    create_table "enumerations", :force => true do |t|
      t.string  "type"
      t.string  "name"
      t.string  "description"
      t.integer "position"
      t.boolean "active"
    end

    add_index "enumerations", ["type"], :name => "enumerations_type_index"
  end

  def self.down
    drop_table "enumerations"
  end
end
CODE

# Copy database.yml for distribution use
run "cp config/database.yml config/database.yml.example"
run "rm -f public/index.html"


# Install plugins as git submodules
plugin 'rspec',
       :git => 'git://github.com/dchelimsky/rspec.git',
       :submodule => true

plugin 'rspec-rails',
       :git => 'git://github.com/dchelimsky/rspec-rails.git',
       :submodule => true

plugin 'open_id_authentication',
       :git => 'git://github.com/rails/open_id_authentication.git',
       :submodule => true

plugin 'exception_logger',
       :git => 'git://github.com/defunkt/exception_logger.git',
       :submodule => true

plugin 'acts-as-taggable-on',
       :git => 'git://github.com/mbleigh/acts-as-taggable-on.git',
       :submodule => true

plugin 'asset_packager',
       :git => 'git://github.com/sbecker/asset_packager.git',
       :submodule => true

plugin 'authlogic',
       :git => 'git://github.com/binarylogic/authlogic.git',
       :submodule => true

plugin 'searchlogic',
       :git => 'git://github.com/binarylogic/searchlogic.git',
       :submodule => true

plugin 'settingslogic',
       :git => 'git://github.com/binarylogic/settingslogic.git',
       :submodule => true

plugin 'shoulda',
       :git => 'git://github.com/thoughtbot/shoulda.git',
       :submodule => true

plugin 'factory_girl',
       :git => 'git://github.com/thoughtbot/factory_girl.git',
       :submodule => true

plugin 'quietbacktrace',
       :git => 'git://github.com/thoughtbot/quietbacktrace.git',
       :submodule => true

plugin 'will_paginate',
       :git => 'git://github.com/mislav/will_paginate.git',
       :submodule => true

plugin 'state_machine',
       :git => 'git://github.com/pluginaweek/state_machine.git',
       :submodule => true

plugin 'project_search',
       :git => 'git://github.com/37signals/project_search.git',
       :submodule => true

plugin 'enhanced_console',
       :git => 'git://github.com/mlightner/enhanced_console.git',
       :submodule => true

plugin 'auto_migrations',
       :git => 'git://github.com/mlightner/auto_migrations.git',
       :submodule => true

plugin 'haml',
       :git => 'git://github.com/nex3/haml.git',
       :submodule => true

plugin 'ar_fixtures',
       :submodule => true,
       :git => 'git://github.com/topfunky/ar_fixtures.git'

plugin 'annotate_models',
       :submodule => true,
       :git => 'git://github.com/ctran/annotate_models.git'

plugin 'enumerations_mixin',
       :submodule => true,
       :git => 'git://github.com/mlightner/enumerations_mixin.git'


# Install all gems
gem 'RedCloth'

# Initialize submodules
git :submodule => "init"

rake('gems:install', :sudo => true)
rake('gems:unpack:dependencies', :sudo => true)

# Set up sessions, RSpec, user model, OpenID, etc, and run migrations
generate("rspec")

unless File.exist?("#{RAILS_ROOT}/config/application.yml")
# Sample application settings file
file 'config/application.yml', <<-CODE
defaults: &defaults

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
CODE
end


rake('db:sessions:create')
generate("authlogic", "user session")

# Database probably isn't created at this point...
rake('db:migrate')
rake('annotate_models')

unless `grep 'user_sessions' #{RAILS_ROOT}/config/routes.rb` =~ /\w/
  route "map.resource :account, :controller => 'users'"
  route "map.resources :users"
  route "map.resource :user_session"
  route "map.root :controller => 'user_sessions', :action => 'new'"
end

# Commit all work so far to the repository
git :add => '.'
git :commit => "-a -m 'Initial commit from template'"

# Success!
puts "================== SUCCESS! =================="
