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

Note that this requires Rails 2.3 in order to function.  Assuming you have Rails 2.3 installed, to use the template
for a new application, run:

  ./script/plugin install git://github.com/mlightner/loaded_rails_template.git
  rake loaded_rails_template

If you don't have Rails 2.3 installed yet, you can freeze your app to edge Rails and then run the plugin's rake task.



Copyright (c) 2009 Matt Lightner, released under the MIT license