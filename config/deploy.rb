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
before 'deploy:restart', 'deploy:symlink_secret_token'

namespace :deploy do
  task :create_secret_token do
    secret_token_contents = "Graylog2WebInterface::Application.config.secret_token = \"#{::SecureRandom.hex(128)}\""
    file = "#{shared_path}/secret_token.rb"
    unless remote_file_exists?(file)
      run "echo -e '#{secret_token_contents}' > #{file}"
    end
  end
  task :symlink_secret_token do
    create_secret_token
    run "ln -snf #{shared_path}/secret_token.rb #{current_path}/config/initializers/"
  end
end

# http://stackoverflow.com/questions/1661586/how-can-you-check-to-see-if-a-file-exists-on-the-remote-server-in-capistrano
# .. with fixes
def remote_file_exists?(path)
  results = []
  invoke_command("if [ -e '#{path}' ]; then echo -n 'true'; fi") do |ch, stream, out|
    results << (out == 'true')
  end
  results.length > 0 && results.all?
end