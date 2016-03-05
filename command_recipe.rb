execute "yum-update" do
	user "root"
	command "yum -y update"
	action :run
end

execute "update timezone UTC->JST" do
	command "cp /usr/share/zoneinfo/Japan /etc/localtime"
	user "root"
end

file '/etc/sysconfig/i18n' do
    action :edit
    user "root"
    block do |content|
        content.gsub!("en_US", "ja_JP")
    end
end

remote_file "/home/vagrant/.vimrc" do
	source "templates/.vimrc"
	owner 'vagrant'
	group 'vagrant'
end
remote_file "/root/.vimrc" do
	source "templates/.vimrc"
	owner 'root'
	group 'root'
end

service 'firewalld' do
	action [:disable, :stop]
end
