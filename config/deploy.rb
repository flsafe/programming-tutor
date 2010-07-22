#-- User Names
# user: the user on the server to login with
# db_user: The app database user name
#--
set :db_user, 'blueberrytree'
set :user,    'flicea'

#-- Repository info
# scm_domain: Where is the repo located?
# scm_user: Username for the repo account
# project_name: The name of the project in the repo
set :scm_domain,   'git@github.com'
set :scm_user,     'flsafe'
set :project_name, 'blueberryrow'
set :repository,    "#{scm_domain}:#{scm_user}/#{project_name}.git" 

#-- Where the application will be deployed
set :domain, 'blueberrytree.ws'
set :application_name, 'blueberrytree'
set :deploy_to, "/home/#{user}/#{application_name}" 

# distribute your applications across servers (the instructions below put them
# all on the same server, defined above as 'domain', adjust as necessary)
role :app, domain
role :web, domain
role :db, domain, :primary => true

# you might need to set this if you aren't seeing password prompts
# default_run_options[:pty] = true

# As Capistrano executes in a non-interactive mode and therefore doesn't cause
# any of your shell profile scripts to be run, the following might be needed
# if (for example) you have locally installed gems or applications.  Note:
# this needs to contain the full values for the variables set, not simply
# the deltas.
# default_environment['PATH']='<your paths>:/usr/local/bin:/usr/bin:/bin'
# default_environment['GEM_PATH']='<your paths>:/usr/lib/ruby/gems/1.8'

# miscellaneous options
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false

# task which causes Passenger to initiate a restart
namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end
end

# Tasks that maintain the app gems between deployments
namespace :gems do
  task :bundle_install, :roles=>:app do
    gems.symlink_shared_gems
    run "cd #{release_path} && bundle install #{release_path}/vendor/gems"
  end
  
  task :symlink_shared_gems, :roles=>:app do
    gems.create_gem_dir
    run <<-CMD
      rm -rf #{release_path}/vendor/gems &&
      ln -nsf #{shared_path}/gems #{release_path}/vendor/gems
    CMD
  end
  
  task :create_gem_dir, :roles=>:app do
    run "mkdir -p #{shared_path}/gems"
  end
end

after "deploy:update_code", "gems:bundle_install"


# optional task to reconfigure databases -- Not being used for now
 # after "deploy:update_code", :configure_database
 # desc "copy database.yml into the current release path"
 # task :configure_database, :roles => :app do
 #   db_config = "#{deploy_to}/config/database.yml"
 #   run "cp #{db_config} #{release_path}/config/database.yml"
 # end
