role :production, "capi@ruby03", "capi@ruby02", "capi@ruby01"
role :migration, "capi@ruby02"
role :qa, "capi@qa02"
default_run_options[:pty] = true

set :base, "/var/www/"
set :application, "surveys"
set :latest_tag_dir, "tmp/latest_tag"
set :app_dir, "#{base}#{application}"
set :branch, "master"
set :qa_branch, "qa"


task :create_tag, :roles => :migration do
  puts "Deploying to #{roles} in directory #{app_dir}"
  puts "Tagging the current version before updating..."
  # Tag the current version before updating
  timestamp = Time.now.strftime("%Y%m%d%H%M%S")
  tag_name = "tutor_#{timestamp}"  
  run "cd #{app_dir} &&  sudo git tag #{tag_name}"
  run "cd #{app_dir} &&  sudo git push --tags"
  # Create an empty file with our tag name, so we can easily go grab the tagname for rollback
  run "sudo rm -f #{File.join(app_dir, latest_tag_dir, '*')}"
  run "sudo touch #{File.join(app_dir, latest_tag_dir, tag_name)}"
  puts "Setting latest tag as #{tag_name}"
  @tag = tag_name
end

task :get_tag, :roles => :migration do
  run "ls " + File.join(app_dir, latest_tag_dir).to_s do |ch, stream, data|
    if stream == :err
      puts "capured output on STDERR: #{data}"
    else # stream == :out
      data = data.strip
      @tag = data
      puts "Latest tag is #{@tag}"
    end
  end
end

task :deploy_no_tag, :roles => :production do   #roles => :production
  puts "Deploying to #{roles} in directory #{app_dir}"  
  run "cd #{app_dir} && sudo git checkout #{branch}" # make sure we're on the right branch
  run "cd #{app_dir} && sudo git pull" # get head
  run "sudo chown -R www:www #{app_dir}" # chown to www
  run "sudo rm #{app_dir}/tmp/restart.txt" # restart
  run "sudo touch #{app_dir}/tmp/restart.txt" # restart
end

task :deploy do
  unless @tag_created
    create_tag
     @tag_created = true
  end
  get_tag
  deploy_no_tag
end

task :rollback, :roles => :production do
  puts "Rolling back to latest tag on #{roles} in directory #{app_dir}"
  unless @got_tag
    get_tag
    @got_tag = true
  end
  run "cd #{app_dir} && sudo git checkout #{@tag}"
  puts "Restarting..."
  run "sudo chown -R www:www #{app_dir}" # chown to www
  run "sudo rm #{app_dir}/tmp/restart.txt" # restart
  run "sudo touch #{app_dir}/tmp/restart.txt" # restart
end

task :migrate, :roles => :migration do
  puts "Migrating in #{roles} in directory #{app_dir}"
  run "cd #{app_dir} && sudo git checkout #{branch}" # make sure we're on the right branch
  run "cd #{app_dir} && sudo git pull" # get head
  run "cd #{app_dir} && sudo /opt/ruby_ent/bin/rake db:migrate --trace RAILS_ENV=production" # get head
end

task :restart, :roles => :production do
  puts "Restarting #{roles} in directory #{app_dir}"
  run "sudo chown -R www:www #{app_dir}" # chown to www
  run "cd #{app_dir} && sudo /opt/ruby_ent/bin/rake ultrasphinx:configure RAILS_ENV=production" 
  run "cd #{app_dir} && sudo /opt/ruby_ent/bin/rake ultrasphinx:index RAILS_ENV=production" 
  run "cd #{app_dir} && sudo /opt/ruby_ent/bin/rake ultrasphinx:daemon:restart RAILS_ENV=production" 
  run "sudo rm #{app_dir}/tmp/restart.txt" # restart
  run "sudo touch #{app_dir}/tmp/restart.txt" # restart
end

task :deploy_with_sphinx_config, :roles => :production do
  puts "Deploying to #{roles} in directory #{app_dir}"
  run "cd #{app_dir} && sudo git checkout #{branch}" # make sure we're on the right branch
  run "cd #{app_dir} && sudo git pull" # get head
  run "cd #{app_dir} && sudo /opt/ruby_ent/bin/rake ultrasphinx:configure RAILS_ENV=production" 
  run "cd #{app_dir} && sudo /opt/ruby_ent/bin/rake ultrasphinx:index RAILS_ENV=production" 
  run "cd #{app_dir} && sudo /opt/ruby_ent/bin/rake ultrasphinx:daemon:restart RAILS_ENV=production" 
  run "sudo chown -R www:www #{app_dir}" # chown to www
  run "sudo rm #{app_dir}/tmp/restart.txt" # restart
  run "sudo touch #{app_dir}/tmp/restart.txt" # restart
end
