require_relative 'env'

HOST = ARGV[0] || DEFAULT_HOST

raise "Please specify HOST via env.rb or script argument." if !HOST || HOST == ""

USER = "root"

def main
  exe "apt-get update -y"

  exe "apt-get install -y build-essential ruby git redis-server cmake vim wget curl libsqlite3-dev python apt-transport-https ca-certificates automake libtool libzlcore-dev libyaml-dev openssl libssl-dev zlib1g-dev libreadline-dev libcurl4-openssl-dev software-properties-common ruby-dev libmysqld-dev"

  exe "gem i bundler git-up passenger --no-ri --no-rdoc"

  # setup www user
  exe "useradd -s /bin/bash www"
  exe "mkdir -p /www"
  exe "mkdir -p /home/www"
  exe "chown -R www:www /www"
  exe "chown -R www:www /home/www"

  # install node
  node_version = "8.1.4" # 'current'
  exe "mkdir -p ~/tmp"

  # from binary
  #
  arch = "x64"
  arch = "arm64" if ENV["ARM"] == "1"
  name = "node-v#{node_version}-linux-#{arch}"
  exe "cd ~/tmp && wget https://nodejs.org/dist/v#{node_version}/#{name}.tar.gz"
  exe "cd /usr/local && tar --strip-components 1 -xzf ~/tmp/#{name}.tar.gz"

  exe "npm i -g coffee-script pm2"

  exe "chown -R www:www /usr/local/lib/ruby/gems/"
  exe "chown -R www:www /usr/local/bin/"
  exe "chown -R www:www /var/lib/gems/2.3.0"


  exe "passenger-install-nginx-module --auto --auto-download"

  exe "systemctl stop nginx"
  nginx_upstart_conf = "https://raw.githubusercontent.com/makevoid/nginx-passenger-ubuntu/master/nginx/nginx.service"
  exe "curl #{nginx_upstart_conf} > /lib/systemd/system/nginx.service"
  exe "systemctl daemon-reload"
  exe "systemctl enable nginx"
  exe "systemctl start  nginx"
  exe "systemctl status nginx"

  exe "curl https://raw.githubusercontent.com/makevoid/servtools/master/config/nginx.conf > /opt/nginx/conf/nginx.conf"
  exe "/opt/nginx/sbin/nginx -t" # test the conf

  exe "mkdir -p /opt/nginx/vhosts"

  wexe "pm2 startup"
  exe "su -c 'env PATH=$PATH:/usr/local/bin pm2 startup linux -u www --hp /home/www'"
end

PROVISIONING.call
