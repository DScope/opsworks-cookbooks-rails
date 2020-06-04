node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  release_path = "#{deploy[:deploy_to]}/current/"
  execute "sudo chown #{deploy[:user]} #{deploy[:deploy_to]}/shared/ -R " do
  end
  execute "rake sidekiq:stop" do
    cwd           release_path
    user "#{deploy[:user]}"
    command "RAILS_ENV=#{rails_env} bundle exec sidekiqctl stop #{deploy[:deploy_to]}/shared/pids/sidekiq.pid 70"
    returns [0,1]
  end

  execute "rake sidekiq:start" do
    user "#{deploy[:user]}"
    command       "RAILS_ENV=#{rails_env} bundle exec sidekiq -d"
    cwd           release_path
    returns [0,1]
  end
  execute "sudo chmod -R 776 #{release_path}" do
  end
  execute "sudo chown #{deploy[:user]} #{release_path} -R" do
  end
  execute "sudo chown #{deploy[:user]} #{deploy[:deploy_to]}/shared/log -R " do
  end
end
