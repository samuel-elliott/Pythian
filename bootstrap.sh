#!/usr/bin/env bash
# Sam Elliott
# Monday, 11 July 2016

# This updates Apt repo data and then updates all available packages.
sudo apt-get update
sudo apt-get upgrade -y

# This installs Nginx, fires it up, and configures it to start upon system
# reboot.
sudo apt-get -y install nginx
sudo service nginx start
sudo update-rc.d nginx enable 2345

# It seems this box spins up set to the UTC timezone. This is being coded in
# NYC so let's update the timezone accordingly.
sudo timedatectl set-timezone America/New_York

# Alters Document Root for Default site to something I'm used to and then
# reloads Nginx for said change to take effect
sudo sed -i 's|'root\ /usr/share/nginx/html'|root\ /var/www|g' /etc/nginx/sites-available/default
sudo service nginx reload

# Creates a handy symlink between the Vagrant directory's root and /var/www
ln -s /vagrant /var/www

# Outputs a new index.html page to overwrite the default "Nginx is working"
# page

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
cat > /var/www/index.html
cat << _EOF_
<!doctype
<html>
<head>
    <title>
    Sam Elliott's Default Title Page
    </title>
</head>

<body>
    <p>Sam Elliott's Pythian index.html file.</p>
    <p>Pecan pie is the best kind of pie there is.</p>
    <p>Apple pie is a decent-enough runner-up.</p>
    <p>Pumpkin pie is the result of someone with<br>
    too much time and baby food on their hands.</p>
    <p><b>Please check /home/vagrant/dyndns.log<br>
    for all your external IP address needs!</b></p>
</body>
</html>
_EOF_

fi

# Copies check_ip.py from shared directory to /home/vagrant
cp -p /vagrant/check_ip.py /home/vagrant/

# Call me crazy but I think this runs the python script in the background so
# running 'vagrant up' doesn't hang towards the end when it is run.
python /home/vagrant/check_ip.py &