FROM centos


USER root

COPY ./root /

#
# stage utility scripts
#

COPY ./bin/add-imap-user-to-image /opt/.add-imap-user-to-image

#
# add the operational user 'dovecot'
#

ENV DOVECOT_USER_UID 20205
ENV DOVECOT_USER_GID 20205

RUN mkdir -p /opt/dovecot/home/ && \
    groupadd -g ${DOVECOT_USER_GID} dovecot && \
    useradd -m -g ${DOVECOT_USER_GID} -u ${DOVECOT_USER_UID} -d /opt/dovecot/home/dovecot dovecot && \
    chown -R ${DOVECOT_USER_UID}:${DOVECOT_USER_GID} /opt/dovecot && \
#
# add IMAP users ...
#
    /opt/.add-imap-user-to-image ovidiu \
        --dovecot-conf-file=/opt/dovecot/conf/dovecot.conf && \
#
# remove utility scripts
#
    rm /opt/.add-imap-user-to-image


