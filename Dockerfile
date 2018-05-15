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
ENV IMAPUSERS_GID 20206

USER root

COPY ./root /

VOLUME /opt/dovecot/external

#
# stage utility scripts
#

COPY ./bin/add-imap-user-to-image /opt/.tmp/add-imap-user-to-image

RUN yum install -y iproute net-tools gettext openssl && \
  mkdir -p /opt/dovecot/home/ && \
  groupadd -g ${DOVECOT_USER_GID} dovecot && \
  useradd -m -g ${DOVECOT_USER_GID} -u ${DOVECOT_USER_UID} -d /opt/dovecot/home/dovecot dovecot && \
  chown -R ${DOVECOT_USER_UID}:${DOVECOT_USER_GID} /opt/dovecot && \
#
# This group will insure that all IMAP users can create the initial directory layout in
# the external IMAP data directory
#
  groupadd -g ${IMAPUSERS_GID} imapusers && \
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
   --imapusers-gid=${IMAPUSERS_GID} \
   --dovecot-conf-file=/opt/dovecot/conf/dovecot.conf \
   --dovecotpw=/opt/dovecot/bin/dovecotpw && \
#
# remove utility scripts
#
  rm -r /opt/.tmp && \
#
# adjust /opt/dovecot/external permissions
#
  chmod 0775 /opt/dovecot/external && \
#
# adjust /opt/dovecot/run/login permissions
#
  chown root /opt/dovecot/run/login && \
  chmod o-rwx /opt/dovecot/run/login && \
#
# various linnks
#
  mkdir /usr/local/libexec/dovecot && \
  ln -s /opt/dovecot/bin/ssl-build-param /usr/local/libexec/dovecot

WORKDIR /opt/dovecot

ENTRYPOINT ["./bin/entrypoint"]
