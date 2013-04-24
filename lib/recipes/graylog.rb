namespace :graylog do
  namespace :yaml do
    task :setup do
      set(:shared_config_path, "#{shared_path}/config")
      set(:shared_link, "#{current_path}/graylog_config")
      set(:config_path, "#{current_path}/config")
      set(:configs, %w/general indexer ldap mongoid/)
    end

    desc "Check that we've installed the proper yaml config files"
    task :check do
      setup
      run "test -h #{shared_link}"
      configs.each do |config|
        run "test -f #{shared_link}/#{config}.yml"
      end
    end

    desc "Install yaml from examples"
    task :install do
      setup
      run "mkdir -p #{shared_config_path}"
      configs.each do |config|
        run "rsync -av --ignore-existing #{config_path}/#{config}.yml.example #{shared_config_path}/#{config}.yml"
        run "ln -s #{shared_config_path}/#{config}.yml #{config_path}/#{config}.yml"
      end
    end
  end
end
