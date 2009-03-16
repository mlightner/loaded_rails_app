Fully Loaded Rails Application Template
=======================================

A Rails application template as described here: http://m.onkey.org/2008/12/4/rails-templates

This template installs quite a few plugins and optionally attempts to automatically setup a mySQL database for
your application (assuming your root mySQL user's login info is stored in /root/.my.cnf)

This template is written to allow it to be run multiple times and shouldn't (no guarantees) destroy
existing configuration data.

Use at your own risk!


Usage
=====

This template is distributed as a normal Rails plugin and invoked via a Rake task (which, in turn, invokes the
rails:template task).

Note that this requires Rails 2.3 in order to function.  Assuming you have Rails 2.3 installed, to use the template on
your application, from its root directory, run:

    ./script/plugin install git://github.com/mlightner/loaded_rails_app.git
    rake loaded_rails_app

If you don't have Rails 2.3 installed yet, you can freeze your app to edge Rails and then run the plugin's rake task.


Example Output
==============

    root@feynman [/home/yourapp/yourapp]# rake loaded_rails_app
    (in /home/yourapp/yourapp)
        applying  template: /home/yourapp/yourapp/vendor/plugins/loaded_rails_app/tasks/../lib/template.rb
         running  git init
       executing  find . -type d -empty | xargs -I xxx touch xxx/.gitignore from /home/yourapp/yourapp
    	file  .gitignore
         running  git submodule init
    	      Would you like the script to attempt to setup your database (for mySQL users with root access only)?
    y
    	      What would you like to use as the database prefix? [yourapp]

    	file  config/database.yml
    	file  db/migrate/0_create_users.rb
    	file  db/migrate/1_virtual_enumerations.rb
       executing  cp config/database.yml config/database.yml.example from /home/yourapp/yourapp
       executing  rm -f public/index.html from /home/yourapp/yourapp
          plugin  rspec
          plugin  rspec-rails
          plugin  open_id_authentication
          plugin  exception_logger
          plugin  acts_as_taggable_redux
          plugin  asset_packager
          plugin  authlogic
          plugin  searchlogic
          plugin  settingslogic
          plugin  shoulda
          plugin  factory_girl
          plugin  quietbacktrace
          plugin  will_paginate
          plugin  aasm
          plugin  fancy_rake
          plugin  enhanced_console
          plugin  auto_migrations
          plugin  ansi
          plugin  mysql_setup
          plugin  active_scaffold
          plugin  haml
          plugin  ar_fixtures
          plugin  enumerations_mixin
          plugin  annotate_models
    	 gem  RedCloth
         running  git submodule init
    	rake  gems:install
      generating  rspec
    	rake  mysql_setup:full
    	file  config/application.yml
    	rake  db:sessions:create
      generating  authlogic
    	rake  acts_as_taggable:db:create
    	rake  db:migrate
    	rake  annotate_models
           route  map.resource :account, :controller => 'users'
           route  map.resources :users
           route  map.resource :user_session
           route  map.root :controller => 'user_sessions', :action => 'new'
         running  git add .
         running  git commit -a -m 'Initial commit from template'
         ================== SUCCESS! ==================
         applied  /home/yourapp/yourapp/vendor/plugins/loaded_rails_app/tasks/../lib/template.rb


_Copyright (c) 2009 Matt Lightner, released under the MIT license_
