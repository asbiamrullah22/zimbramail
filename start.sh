echo 'export LC_ALL="en_US.UTF-8"' >> /root/.bashrc
locale-gen en_US.UTF-8

echo 'cat /etc/resolv.conf > /tmp/resolv.ori' > /services.sh
echo 'echo "nameserver 127.0.0.1" > /tmp/resolv.add' >> /services.sh
echo 'cat /tmp/resolv.add /tmp/resolv.ori > /etc/resolv.conf' >> /services.sh
echo '/etc/init.d/bind9 restart' >> /services.sh
echo '/etc/init.d/rsyslog restart' >> /services.sh
#RUN echo '/etc/init.d/zimbra restart' >> /services.sh
chmod +x /services.sh

/services.sh

curl -k https://raw.githubusercontent.com/asbiamrullah22/zimbra/master/dns-auto.sh > /srv/dns-auto.sh
chmod +x /srv/dns-auto.sh

/srv/dns-auto.sh

## Install Zimbra
echo "Downloading Zimbra OpenSource 8.8.15"
wget -O /opt/zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220.tgz https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220.tgz
echo "Extracting files from the archive"
tar -xzvf /opt/zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220.tgz -C /opt/

echo "Update package cache"
apt update

echo "Installing Zimbra Collaboration just the Software"
cd /opt/zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220 && ./install.sh

su - zimbra -c 'zmcontrol restart'
echo "You can access now to your Zimbra 8.8.15"


if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
