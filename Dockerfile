FROM ubuntu:14.04
MAINTAINER Jason Kingsbury <jason@relva.co.uk>

EXPOSE 5900
EXPOSE 4713

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

RUN apt-mark hold initscripts udev plymouth mountall
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

RUN sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list

ADD google_linux_signing_key.pub /tmp/google_linux_signing_key.pub
RUN apt-key add /tmp/google_linux_signing_key.pub && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && adduser --disabled-password --system chrome

RUN apt-get update && apt-get upgrade -y --force-yes && apt-get dist-upgrade -y --force-yes \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
        hicolor-icon-theme \
        x11vnc xvfb \
        google-chrome-stable \
        pulseaudio \
        fluxbox \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /    
    
ADD default.pa /etc/pulse/default.pa
ADD fluxbox_init /etc/fluxbox_init
ADD master_preferences /opt/google/chrome/
ADD desktop-init /usr/bin/
RUN chmod a+rx /usr/bin/desktop-init

ADD supervisord.conf /

CMD ["/usr/bin/desktop-init"]
