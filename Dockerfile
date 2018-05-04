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

RUN yum install -y iproute net-tools && \
    mkdir -p /opt/dovecot/home/ && \
    groupadd -g ${DOVECOT_USER_GID} dovecot && \
    useradd -m -g ${DOVECOT_USER_GID} -u ${DOVECOT_USER_UID} -d /opt/dovecot/home/dovecot dovecot && \
    chown -R ${DOVECOT_USER_UID}:${DOVECOT_USER_GID} /opt/dovecot && \
#
# Add IMAP users. The uid/gid/password of an IMAP user will be built into conf/passwd and conf/userdb,
# and it will also be referred from the conf file (first_valid_uid/last_valid_uid). No OS-level user
# needs to be created, just we need to make sure there's no uid/gid conflict.
#
    /opt/.add-imap-user-to-image ovidiu \
        --uid=58580 \
        --gid=58580 \
        --dovecot-conf-file=/opt/dovecot/conf/dovecot.conf && \
#
# remove utility scripts
#
    rm /opt/.add-imap-user-to-image && \
#
# adjust /opt/dovecot/run/login permissions
#
    chown root /opt/dovecot/run/login && \
    chmod o-rwx /opt/dovecot/run/login

WORKDIR /opt/dovecot

ENTRYPOINT ["/opt/dovecot/bin/dovecot", "-F", "-c", "/opt/dovecot/conf/dovecot.conf"]
