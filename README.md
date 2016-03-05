# Vagrant-Itamae

#### 編集箇所
/node.json  
上記に定義はしているが全てに反映させられていないので注意  
ちゃんと統一しないと意味無いですねｗ

/templates/config.inc.php  
`$cfg['blowfish_secret'] = '46文字';`

/templates/default.conf  
server_nameやドキュメントルートの設定箇所

####作業手順

`gem intall bunder`  
`bundle install --path vendor/bundler`  

取り敢えずitamaeが実行できる事をバージョン表示で確認  
`bundle exec itamae version`

`vagrant up`

レシピ実行  
`bundle exec itamae ssh --vagrant --node-json node.json include_recipe.rb`


####構築環境
`nginx -v`  
`nginx version: nginx/1.0.15`  

`php-fpm -v`  
`PHP 5.5.33 (fpm-fcgi) (built: Mar  2 2016 14:43:32)`

MySQL  
5.5.48

phpMyAdmin  
4.5.3.1
