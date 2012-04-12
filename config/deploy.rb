#config/deploy.rb
require 'bundler/capistrano'

set :application, "dandan"
set :scm, :git
set :deploy_via, :remote_cache       
set :repository,  "git@github.com:xxd/drails.git" 
set :stages, %w(production staging)
set :default_stage, "staging"
#set :git_enable_submodules,1
set :use_sudo, false
# set task count
set :task_count, '18'

default_run_options[:pty] = true
#@domain = domain rescue nil  
#set :domain, "luexiao.com" unless @domain  

# production
task :production do
  set  :rails_env,   :production
  role :web,        "74.207.224.81"                         # Your HTTP server, Apache/etc
  role :app,        "74.207.224.81"                         # This may be the same as your `Web` server
  role :db,         "74.207.224.81", :primary => true       # This is where Rails migrations will run
  role :db,         "74.207.224.81"                         #slave db
  set  :user,        "ddyw"
  set  :password,    "ddyw123"
  set  :branch,      "mater"
end
# staging
task :staging do
  set  :rails_env,   :test
  role :web,        "74.207.224.81"                         # Your HTTP server, Apache/etc
  role :app,        "74.207.224.81"                         # This may be the same as your `Web` server
  role :db,         "74.207.224.81", :primary => true       # This is where Rails migrations will run
  role :db,         "74.207.224.81"                         #slave db
  set  :user,        "ddyw"
  set  :password,    "ddyw123"
  set  :branch,      "master"
  # symlink the config/database.yml
  after "deploy:update_code", "config:db_symlink"
end


if stages.include?(ARGV.first)
  # Execute the specified stage so that recipes required in stage can contribute to task list
  find_and_execute_task(ARGV.first) if ARGV.any?{ |option| option =~ /-T|--tasks|-e|--explain/ }
else
  # Execute the default stage so that recipes required in stage can contribute tasks
  find_and_execute_task(default_stage) if exists?(:default_stage)
end

set :bundle_flags,    "--quiet"
set :deploy_to, "/prod/dev/#{application}"
set :application_path, "#{deploy_to}/current"
set :sp_folder, "#{application_path}/app/Stored procedures"
set :public_path, "#{application_path}/public"

#ruby
set :ruby_binary, "/usr/local/rvm/rubies/ruby-1.9.2-p290/bin/ruby"

# Unicorn
set :bundle_binary, "/usr/local/rvm/gems/ruby-1.9.2-p290/bin/bundle"
set :unicorn_binary, "#{bundle_binary} exec unicorn_rails"
set :unicorn_config, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/current/tmp/pids/unicorn.pid"
set :rake, "#{bundle_binary} exec rake"

set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.2-p290/bin:/usr/local/rvm/gems/ruby-1.9.2-p290@global/bin:/usr/local/rvm/rubies/ruby-1.9.2-p290/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  'RUBY_VERSION' => '1.9.2-p290',
  'GEM_HOME' => '/usr/local/rvm/gems/ruby-1.9.2-p290',
  'GEM_PATH' => '/usr/local/rvm/gems/ruby-1.9.2-p290:/usr/local/rvm/gems/ruby-1.9.2-p290@global'
}

#Bundler
set :bundle_gemfile,  "Gemfile"
set :bundle_dir,      File.join(fetch(:shared_path), 'bundle')
set :bundle_without,  [:development, :test]
set :bundle_cmd,      "bundle" # e.g. "/opt/ruby/bin/bundle"
set :bundle_roles,    {:except => {:no_release => true}}

# God
set :current_restart_task, "none" #using in god

after "deploy", "deploy:cleanup"
#after "deploy:cleanup", "deploy:web:enable"
after "deploy:update_code", "rvm:trust_rvmrc"
#after "deploy:assets_pre", "deploy:web:disable"
before "deploy:create_symlink", "deploy:assets_pre"

namespace :deploy do
  desc <<-DESC
  Change the default action of deploy:cold including db:create.
    update source code -> create database -> migrate -> precomiple assets -> start unicorn -> start resque
  DESC
  task :cold do
    update
    create
    migrate
    start
    #resque.start
  end
  desc "Precompile assets"
  task :assets_pre, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && RAILS_ENV=#{rails_env} #{rake} assets:clean && RAILS_ENV=#{rails_env} #{rake} assets:precompile"
  end
  desc "create the database"
  task :create, :roles => :db, :except => { :no_release => true } do
    run "cd #{application_path} && #{rake} db:create RAILS_ENV=#{rails_env}"
  end
  desc "Refresh the assets and start the unicorn "
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{application_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  desc "Stop the uniron"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "kill `cat #{unicorn_pid}`"
  end
  desc "Stop unicorn with the QUIT signal"
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
  desc "Reload the unicorn with the signal USR2"
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
  desc "Restart unicorn & Refresh the assets"
  task :restart, :roles => :app, :except => { :no_release => true } do

    stop
    start
    #restart sphinx
    #thinking_sphinx.restart

    #enable web
    deploy.web.enable

    #start resque
    # resque.restart
    # resque.restart_scheduler
    #start god
    #god.start_god
    #  %w(unicorn resque_workers resque_scheduler).each do |daemon|
    #    set :current_restart_task, daemon
    #    god.restart_worker
    #  end
    #  set :current_restart_task, "none"
  end
  desc "Bundle install"
  task :bundle, :roles => :app, :except => { :no_release => true } do
    run "cd #{application_path} && #{bundle_binary} install --without development test"
  end
  namespace :web do
    # add the page for maintenance
    desc <<-DESC
    Present a maintenance page to visitors. Disables your application's web
    interface by writing a "maintenance.html" file to each web server. The servers
    must be configured to detect the presence of this file, and if it is present,
      always display it instead of performing the request.
    DESC
    task :disable, :roles => :web, :except => { :no_release => true } do
      on_rollback { delete "#{shared_path}/system/maintenance.html" }
      tgz_path = "#{shared_path}/system/maintenance.tar.gz"
      run "cp #{public_path}/maintenance.tar.gz #{shared_path}/system  && tar zxf #{tgz_path} -C #{shared_path}/system && rm -f #{tgz_path}"
    end

    desc <<-DESC
    Makes the application web-accessible again. Removes the "maintenance.html" page
    generated by deploy:web:disable, which (if your web servers are configured
                                            correctly) will make your application web-accessible again
    DESC
    task :enable, :roles => :web, :except => { :no_release => true } do
      run "rm -f #{shared_path}/system/maintenance.html"
    end
  end
end

namespace :logs do
  desc <<-DESC
  See the logs of rails application.
    You can simplify see the last 10 lines of the logs with
  $ cap logs:watch
  You can also specify the lines with
  $cap logs:watch -s line=20
  DESC
  task :watch do
    line = variables.has_key?(:line ) ? variables[:line] : 10
    logs = %w(unicorn.log production.log resque_err resque_stdout)
    logs.each { |log| stream("cd #{application_path} && tail -n #{line} -v log/#{log}") }
  end
end

namespace :resque do
  desc "Start resque works"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{application_path} && RAILS_ENV=#{fetch(:rails_env).to_s} #{ruby_binary} script/resque start"
  end
  desc "Stop  resque works"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{application_path} && RAILS_ENV=#{fetch(:rails_env).to_s} #{ruby_binary} script/resque stop"
  end
  desc "Restart resque works"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{application_path} && RAILS_ENV=#{fetch(:rails_env).to_s} #{ruby_binary} script/resque restart"
  end
  desc "Start the resque scheduler"
  task :start_scheduler, :roles => :app, :except => { :no_release => true } do
    run "cd #{application_path} && RAILS_ENV=#{fetch(:rails_env).to_s} #{ruby_binary} script/resque_scheduler start"
  end
  desc "Stop the resque scheduler"
  task :stop_scheduler, :roles => :app, :except => { :no_release => true } do
    run "cd #{application_path} && RAILS_ENV=#{fetch(:rails_env).to_s}#{ruby_binary} script/resque_scheduler stop"
  end
  desc "Restart the resque scheduler"
  task :restart_scheduler, :roles => :app, :except => { :no_release => true } do
    run "cd #{application_path} && RAILS_ENV=#{fetch(:rails_env).to_s} #{ruby_binary} script/resque_scheduler restart"
  end
end

namespace :rvm do
  desc  "trust rvm file"
  task :trust_rvmrc, :roles => :app, :except => { :no_release => true } do
    run "rvm rvmrc trust #{release_path}"
  end
end

namespace :config do
  desc "symlink databse.yml"
  task :db_symlink, :roles => :db, :except => { :no_release => true } do
    target = File.join(fetch(:release_path),"config/database.yml")
    source = File.join(fetch(:shared_path),"config/database.yml")
    raise "the config file is not existed!" if target.nil? or source.nil?
    run "rm -f #{target} && ln -s #{source} #{target}"
  end
end
#namespace :god do
#  desc "Start god"
#  task :start_god, :roles => :app, :except => { :no_release => true } do
#    run "cd #{application_path} && #{bundle_binary} exec god -c #{application_path}/script/all.god"
#  end
#  desc "Stop god"
#  task :stop_god, :roles => :app, :except => { :no_release => true } do
#    run "cd #{application_path} && #{bundle_binary} exec god quit"
#  end
#  desc "God status"
#  task :status, :roles => :app, :except => { :no_release => true } do
#    run "cd #{application_path} && #{bundle_binary} exec god status"
#  end
#  desc "Restart worker using current_restart_task variable"
#  task :restart_worker, :roles => :app, :except => { :no_release => true } do
#    run "cd #{application_path} && #{bundle_binary} exec god restart #{fetch(:current_restart_task)}"
#  end
#end
#namespace :database do
#  desc "Creating MySQL Stored Procedures"
#  task :create_sp do
#    run %{
#      SP_Folder = #{application_path}/app/Stored procedures
#      for sp in ${SP_Folder}/*; do
#        mysql -uroot magic_development < sp
#      done
#    }
# end
#namespace :sp do
#  desc "Creating Mysql SP without password"
#  task :create_sp, :roles => :db, :except => { :no_release => true } do
#    run "cd #{application_path} && #{fetch(:rake)} sp:create"
#  end
#  desc "Drop **ALL** the Mysql SP"
#  task :drop_sp, :roles => :db, :except => { :no_release => true } do
#    run "cd #{application_path} && #{fetch(:rake)} sp:drop"
#  end
#  desc "Refresh **ALL** the Mysql SP"
#  task :refresh_sp, :roles => :db, :except => { :no_release => true } do
#    run "cd #{application_path} && #{fetch(:rake)} sp:refresh"
#  end
#end
#
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
