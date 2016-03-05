package "epel-release"
package 'http://rpms.famillecollet.com/enterprise/remi-release-6.rpm' do
  not_if "rpm -q remi-release"
end

package 'nginx' do
    action :install
end

file "/var/log/nginx/access.log" do
	owner 'nginx'
	group 'nginx'
	mode "644"
end
file "/var/log/nginx/error.log" do
	owner 'nginx'
	group 'nginx'
	mode "644"
end

directory "/var/www/vhosts/#{node[:Directory][:www]}/logs" do
	mode "755"
	owner "vagrant"
	group "vagrant"
end

%w(add_header.conf expires.conf gzip.conf).each do |fname|
	remote_file "/etc/nginx/" + fname do
		source "templates/" + fname
		owner 'root'
		group 'root'
	end
end

file '/etc/nginx/nginx.conf' do
    action :edit
    user "root"
    block do |content|
        content.gsub!("sendfile        on", "sendfile        off")
    end
end

remote_file "/etc/nginx/conf.d/default.conf" do
	source "templates/default.conf"
	owner 'root'
	group 'root'
end
