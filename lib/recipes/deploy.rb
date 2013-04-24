namespace :deploy do
  desc "Print the currently deployed revision."
  task :revision do
    logger.info current_revision
  end

  desc "Update the database seeds."
  task :seed do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake --trace db:seed"
  end

  namespace :cache do
    desc 'clear tmp/cache on app servers'
    task :clear do
      run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake tmp:cache:clear"
    end
  end

  desc "Restart Application."
  task :restart, :roles => :web do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :symlink_cache, :except => { :no_release => true } do
    run <<-CMD
      ln -s #{shared_path}/cache #{latest_release}/tmp/cache
    CMD
  end
end

