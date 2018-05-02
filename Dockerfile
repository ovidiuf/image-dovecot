FROM alpine

#
# add the operational user 'dovecot'
#

USER root

RUN echo "dovecot:x:20205:" >> /etc/group && \
    echo "dovecot:x:20205:20205::/opt/dovecot/home/dovecot:/bin/ash" >> /etc/passwd && \
    mkdir -p /opt/dovecot/home/dovecot && \
    chown -R 20205:20205 /opt/dovecot

USER dovecot:dovecot

