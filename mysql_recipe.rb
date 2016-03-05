package 'mysql-server' do
    action :install
    options "--enablerepo=remi"
end

utf8_settting = <<"EOS"

[mysqld]
character-set-server=utf8

read_buffer_size = 2G
read_rnd_buffer_size = 2G
skip_innodb_doublewrite
innodb_flush_log_at_trx_commit = 0

[client]
default-character-set=utf8

[mysql]
default-character-set=utf8

[mysqldump]
default-character-set=utf8

EOS

execute "mysql-set-db-charset-to-utf8" do
  command <<-EOF
    echo '#{utf8_settting}' >> /etc/my.cnf
  EOF
end


service "mysqld" do
  action [ :enable, :start ]
end
execute "mysql-secure-installation" do
    user "root"
    only_if "mysql -u root -e 'show databases' | grep information_schema" # パスワードが空の場合
    command <<-EOL
        mysqladmin -u root password "#{node[:MySQL][:pass]}"
        mysql -u root -p#{node[:MySQL][:pass]} -e "DELETE FROM mysql.user WHERE User='';"
        mysql -u root -p#{node[:MySQL][:pass]} -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');"
        mysql -u root -p#{node[:MySQL][:pass]} -e "DROP DATABASE test;"
        mysql -u root -p#{node[:MySQL][:pass]} -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
        mysql -u root -p#{node[:MySQL][:pass]} -e "FLUSH PRIVILEGES;"
    EOL
end

# DB作成
execute "mysql-create-db" do
  command "mysql -e \"CREATE DATABASE #{node[:MySQL][:db_name]} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;\" -u root -p#{node[:MySQL][:pass]}"
  not_if "mysql -e \"SHOW DATABASES LIKE '#{node[:MySQL][:db_name]}';\" -uroot -p#{node[:MySQL][:pass]} --silent --skip-column-names | grep '#{node[:MySQL][:db_name]}'"
end

# DBユーザー作成
execute "mysql-create-user" do
    command "/usr/bin/mysql -u root --password=\"#{node[:MySQL][:pass]}\"  < /tmp/grants.sql"
    action :nothing
end

template "/tmp/grants.sql" do
    owner "root"
    group "root"
    mode "0600"
    source "templates/grants.sql.erb"
    variables(
        :user     => "#{node[:MySQL][:user]}",
        :password => "#{node[:MySQL][:user_pass]}",
        :database => "#{node[:MySQL][:db_name]}",
    )
    notifies :run, "execute[mysql-create-user]", :immediately
end

