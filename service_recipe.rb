service "sendmail" do
  action [ :disable, :stop ]
end

service "postfix" do
  action [ :enable, :start ]
end
service "dovecot" do
  action [ :enable, :start ]
end

service 'php-fpm' do
	action [:enable, :start]
end

service 'nginx' do
	action [:enable, :start]
end