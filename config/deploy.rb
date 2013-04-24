require 'bundler/capistrano'

set :application, 'graylog2'
set :repository,  'git://github.com/nathantsoi/graylog2-web-interface.git'
set :deploy_via, :remote_cache
set :deploy_to, '/var/www/graylog2'

set :stages, %w/staging production/
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :default_shell, 'bash -l'
set :normalize_asset_timestamps, false

set :branch, fetch(:branch, 'master')

before 'deploy:restart', 'graylog:yaml:install'

after :deploy, 'deploy:cleanup'
