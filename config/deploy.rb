#Based on 'Agile Web Development With Ruby On Rails'

#-- User Names
# user: the user on the server to login with
#--
set :user,    'flicea'

#-- Repository info
# scm_domain: Where is the repo located?
# scm_user: Username for the repo account
# project_name: The name of the project in the repo
set :scm_verbose, true
set :scm, 'git'
set :branch, 'dev'
set :scm_domain,   'git@github.com'
set :scm_user,     'flsafe'
set :project_name, 'blueberryrow'
set :repository,    "#{scm_domain}:#{scm_user}/#{project_name}.git" 

#-- Where the application will be deployed
set :domain, 'blueberrytree.ws'
set :staging_domain, 'staging.blueberrytree.ws'
set :application_name, 'blueberrytree'

task :staging do
  role :web, staging_domain 
  role :app, staging_domain
  role :db, staging_domain, :primary=>true
  set :stage, :staging
end

task :production do
  role :web, domain
  role :app, domain 
  role :db, domain
  set :stage, :production
end

#-- Deploy location depends on the stage
set(:deploy_to) {"/home/#{user}/#{application_name}/#{stage}"}

# miscellaneous options
set :deploy_via, :remote_cache
set :use_sudo, false
set :ruby_path, '/opt/ruby-enterprise-1.8.7-2010.02/bin/'
set( :rails_env ) { stage || 'staging' }

# you might need to set this if you aren't seeing password prompts
# default_run_options[:pty] = true

# As Capistrano executes in a non-interactive mode and therefore doesn't cause
# any of your shell profile scripts to be run, the following might be needed
# if (for example) you have locally installed gems or applications.  Note:
# this needs to contain the full values for the variables set, not simply
# the deltas.
default_environment['PATH']="#{ruby_path}:/sbin/:/usr/local/bin:/usr/bin:/bin"

# We are using bundler for the gem dependencies.
# default_environment['GEM_PATH']='<your paths>:/usr/lib/ruby/gems/1.8'

# task which causes Passenger to initiate a restart
namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end
end

# Create a work directory were solutions and unit tests
# are executed.
namespace :deploy do
  task :create_tmp, :roles=>:app do
    run "mkdir -p #{release_path}/tmp/work"
    run "chmod -R o+rwx #{release_path}/tmp"
  end
end

# Install gems using bundler
namespace :gems do
  task :bundle_install, :roles=>:app do
    if rails_env == 'production'
     ops = "--without test --without development" 
    end
    run "which ruby ; ruby -v; echo $PATH"
    run "cd #{release_path} && bundle install #{ops || ''}"
  end
end

# Install the recondation_engine deps using leiningen
namespace :jars do
  task :jars_install, :roles=>:app do
    if rails_env == 'production'
     ops = "no-dev" 
    end
    run "cd #{release_path}/recomendation-engine && lein deps #{ops || ''}"
  end
end

# Start delayed_job in the context of the
# bundler gems.
namespace :delayed_job do
  desc "Start delayed_job process" 
  task :start, :roles => :app do
    # Only one delayed job daemon at a time. Kill the
    # daemons that may be running from the previous deployment.
    run "( pidof delayed_job && kill `pidof delayed_job`) || true"
    
    # Run delayed job with the same ruby as Passenger.
    run "cd #{current_path}; bundle exec env RAILS_ENV=#{rails_env} #{ruby_path}/ruby script/delayed_job start" 
  end

  desc "Stop delayed_job process" 
  task :stop, :roles => :app do
    run "cd #{current_path}; bundle exec env RAILS_ENV=#{rails_env} script/delayed_job stop" 
  end

  desc "Restart delayed_job process" 
  task :restart, :roles => :app do
    delayed_job.stop
    delayed_job.start
  end
end

# Start the recomendation engine server
namespace :recomendations do
  desc "Start the recomendations server"
  task :start, :roles=> :app do
    # Only one recemendation server should be running at a time 
    # per environment. For example only one rec server in staging.
    #
    # Kill the rec server from the previous release
    recomendations.stop
    run "cd #{current_path}; env RAILS_ENV=#{rails_env} recomendation-engine/start"
  end
  
  desc "Stop the recomendations server"
  task :stop, :roles=> :app do
    # Stop the receomdnation server, but one may not be running
    # so no need to freak if we try to shut it down we get an error
    run "cd #{current_path}; recomendation-engine/stop || true"
  end

  desc "Restart the recomendations server"
  task :restart do
    recomendations.stop
    recomendations.start
  end

  desc "Restart the recomendations server"
  task :restart do
    recomendations.stop
    recomendations.start
  end
end

after "deploy:start", "delayed_job:start" 
after "deploy:start", "recomendations:start"

after "deploy:stop", "delayed_job:stop" 
after "deploy:stop", "recomendations:stop"

after "deploy:restart", "delayed_job:restart" 
after "deploy:restart", "recomendations:restart" 

after "deploy:update_code", "gems:bundle_install"
after "deploy:update_code", "deploy:create_tmp"
after "deploy:update_code", "jars:jars_install"

# optional task to reconfigure databases -- Not being used for now
 # after "deploy:update_code", :configure_database
 # desc "copy database.yml into the current release path"
 # task :configure_database, :roles => :app do
 #   db_config = "#{deploy_to}/config/database.yml"
 #   run "cp #{db_config} #{release_path}/config/database.yml"
 # end
