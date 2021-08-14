FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

#Install Depedensi
RUN apt-get update && apt-get install -y bind9 bind9utils ssh netcat-openbsd sudo libidn11 libpcre3 libgmp10 libexpat1 libstdc++6 libperl5.26 libaio1 resolvconf unzip pax sysstat sqlite3 dnsutils iputils-ping w3m gnupg less lsb-release rsyslog net-tools vim tzdata wget iproute2 locales curl

# Configurasi Time
RUN echo "tzdata tzdata/Areas select Asia\ntzdata tzdata/Zones/Asia select Jakarta" > /tmp/tz ; debconf-set-selections /tmp/tz; rm /etc/localtime /etc/timezone; dpkg-reconfigure -f noninteractive tzdata

VOLUME ["/opt/zimbra"]

RUN mv /etc/init.d/rsyslog /tmp/
RUN curl -k https://raw.githubusercontent.com/asbiamrullah22/zimbra/master/rsyslog > /etc/init.d/rsyslog
RUN chmod +x /etc/init.d/rsyslog

RUN (crontab -l 2>/dev/null; echo "1 * * * * /etc/init.d/rsyslog restart > /dev/null 2>&1") | crontab -

RUN /etc/init.d/rsyslog restart

COPY start.sh .

CMD [ "/bin/bash", "start.sh", "-d" ]
