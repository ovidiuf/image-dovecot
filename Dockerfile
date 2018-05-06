FROM centos

#
# Default values - we expect these to be overridden by docker run command
#
ENV DOVECOT_LISTEN_ADDRESS *
ENV DOVECOT_LISTEN_PORT 143

#
# We don't expect these to be overridden in the command line:
#
# The operational user 'dovecot'
#

ENV DOVECOT_USER_UID 20205
ENV DOVECOT_USER_GID 20205

USER root

COPY ./root /

#
# stage utility scripts
#

COPY ./bin/add-imap-user-to-image /opt/.tmp/add-imap-user-to-image

RUN yum install -y iproute net-tools gettext && \
  mkdir -p /opt/dovecot/home/ && \
  groupadd -g ${DOVECOT_USER_GID} dovecot && \
  useradd -m -g ${DOVECOT_USER_GID} -u ${DOVECOT_USER_UID} -d /opt/dovecot/home/dovecot dovecot && \
  chown -R ${DOVECOT_USER_UID}:${DOVECOT_USER_GID} /opt/dovecot && \
#
# Add IMAP users. The uid/gid/password of an IMAP user will be built into conf/passwd and conf/userdb,
# and it will also be referred from the conf file (first_valid_uid/last_valid_uid). No OS-level user
# needs to be created, just we need to make sure there's no uid/gid conflict. For handling passwords,
# we temporarily use an improvisation: we write the password externally into a /opt/.tmp/.<user-name>
# file and read it at execution time from there. This command will delete it after it is read
#
  /opt/.tmp/add-imap-user-to-image ovidiu \
   --password-file=/opt/.tmp/.ovidiu \
   --uid=58580 \
   --gid=58580 \
   --dovecot-conf-file=/opt/dovecot/conf/dovecot.conf \
   --dovecotpw=/opt/dovecot/bin/dovecotpw && \
#
# remove utility scripts
#
  rm -r /opt/.tmp && \
#
# adjust /opt/dovecot/run/login permissions
#
  chown root /opt/dovecot/run/login && \
  chmod o-rwx /opt/dovecot/run/login

WORKDIR /opt/dovecot

ENTRYPOINT ["./bin/entrypoint"]
