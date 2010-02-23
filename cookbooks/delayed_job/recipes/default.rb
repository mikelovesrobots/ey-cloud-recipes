#
# Cookbook Name:: delayed_job
# Recipe:: default
#
 
if %w(solo app app_master).include?(node[:instance_role])
  user = node[:owner_name]
  framework_env = node[:environment][:framework_env]
 
  # Be sure to replace APP_NAME with the name of your application.
  # The run_for_app method also accepts multiple application name arguments.
  run_for_app('Awwwsum') do |app_name, data|
    worker_name = "#{app_name}_delayed_job"
 
    directory "/data/#{app_name}/shared/pids" do
      owner user
      group user
      mode 0755
    end
 
    template "/etc/monit.d/delayed_job_worker.#{app_name}.monitrc" do
      source 'delayed_job_worker.monitrc.erb'
      owner 'root'
      group 'root'
      mode 0644
      variables(
        :app_name => app_name,
        :user => user,
        :worker_name => worker_name,
        :framework_env => framework_env
      )
    end
 
    bash 'monit-reload-restart' do
      user 'root'
      code 'monit reload && monit'
    end
  end
end
 

