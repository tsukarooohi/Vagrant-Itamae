execute "phpmyadmin-secure-installation" do
    user "root"
    not_if "ls -l /usr/share/ | grep phpMyAdmin" # パスワードが空の場合
    command <<-EOL
        cd /usr/local/src/
        sudo wget https://files.phpmyadmin.net/phpMyAdmin/4.5.3.1/phpMyAdmin-4.5.3.1-all-languages.tar.gz
		sudo tar zxvf phpMyAdmin-4.5.3.1-all-languages.tar.gz
		sudo mv phpMyAdmin-4.5.3.1-all-languages /usr/share/phpMyAdmin
		sudo chown -R root:root /usr/share/phpMyAdmin/
		sudo cp /usr/share/phpMyAdmin/config.sample.inc.php /usr/share/phpMyAdmin/config.inc.php
    EOL
end

remote_file "/usr/share/phpMyAdmin/config.inc.php" do
	source "templates/config.inc.php"
	owner 'root'
	group 'root'
	mode "644"
end

remote_file "/etc/nginx/conf.d/phpmyadmin.conf" do
	source "templates/phpmyadmin.conf"
	owner 'root'
	group 'root'
end
