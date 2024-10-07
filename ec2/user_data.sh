#!/bin/bash -xv
yum update -y
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent && systemctl enable amazon-ssm-agent

yum install httpd -y
systemctl start httpd
systemctl enable httpd

yum install mariadb-server -y
systemctl start mariadb
systemctl enable --now mariadb

amazon-linux-extras install -y php7.4
amazon-linux-enable php7.4


wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rm -rf latest.tar.gz
sudo chmod 2775 /var/www
chown -R apache:apache /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
cp -r wordpress/* /var/www/html/


export db_name=$(aws ssm get-parameter --region=eu-west-1 --name "db_name" --output text --query Parameter.Value)
export db_user=$(aws ssm get-parameter --region=eu-west-1 --name "db_user" --output text --query Parameter.Value)
export db_password=$(aws ssm get-parameter --region=eu-west-1 --name "db_password" --output text --query Parameter.Value)
export db_endpoint=$(aws ssm get-parameter --region=eu-west-1 --name "db_endpoint" --output text --query Parameter.Value)

cd /var/www/html
cp wp-config-sample.php wp-config.php
rm -rf wp-config-sample.php
chmod 644 wp-config.php
sed -i "s/database_name_here/$db_name/g" wp-config.php
sed -i "s/username_here/$db_user/g" wp-config.php
sed -i "s/password_here/$db_password/g" wp-config.php
sed -i "s/localhost/$db_endpoint/g" wp-config.php

sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

yum install -y awslogs
sed -i 's/us-east-1/eu-west-1/g' /etc/awslogs/awscli.conf
systemctl star awslogsd
systemctl enable awslogsd


export url=$(aws ssm get-parameter --region=eu-west-1 --name "load_balancer" --output text --query Parameter.Value)

export title="Nekvoime"
export admin_user="WpUser"
export admin_password="WpAdmPass12"
export admin_email="tsvetan.avramov@helecloud.com"

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp core install --url=$url --title=$title --admin_name=$admin_name --admin_password=$admin_password --admin_email=$admin_email


mysql -h $db_endpoint -u$db_user -p$db_password -e "GRANT ALL PRIVILEGES ON $db_name.* TO $db_user;"
mysql -h $db_endpoint -u$db_user -p$db_password -e "FLUSH PRIVILEGES;"

systemctl restart httpd

yum install -y https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
yum install -y amazon-cloudwatch-agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:cw_agent -s
