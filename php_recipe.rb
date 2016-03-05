package 'http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm' do
	not_if 'rpm -q epel-release-6-8.noarch'
end
package 'http://rpms.famillecollet.com/enterprise/remi-release-6.rpm' do
    not_if 'rpm -q remi-release-6.6-2.el6.remi.noarch'
end

package "php55 php55-opcache php55-devel php55-mcrypt php55-common" do
  action :install
  options "--enablerepo=remi --enablerepo=remi-php55"
end

package "php-fpm php-mbstring php-mysqlnd php-pdo php-bcmath php-cli php-gd php-gmp php-process php-recode php-tidy php-xml" do
  action :install
  options "--enablerepo=remi-php55"
end

remote_file "/etc/php-fpm.d/www.conf" do
	source "templates/www.conf"
	owner 'root'
	group 'root'
end

directory "/var/lib/php/session" do
	owner "root"
	group "nginx"
end

file '/etc/php.ini' do
    action :edit
    user "root"
    block do |content|
        content.gsub!(";date.timezone =", "date.timezone = 'Asia/Tokyo'")
        content.gsub!("expose_php = On", "expose_php = Off")
    end
end
