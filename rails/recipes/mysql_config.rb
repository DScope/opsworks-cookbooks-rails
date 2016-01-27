node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
  puts "Inflating template database.yml.erb"
  template "#{deploy[:deploy_to]}/shared/config/database.yml" do
    source "database.yml.erb"
    cookbook "rails"
    group 'root'
    owner "#{deploy[:user]}"
    mode   "0755"
  end
end
