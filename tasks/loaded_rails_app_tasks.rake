desc "Spec this Rails app out with plugins and whatnot"
task :loaded_rails_app => :environment do
  ENV['LOCATION'] = "#{File.dirname(__FILE__)}/../lib/template.rb"
  Rake::Task["rails:template"].invoke
end
