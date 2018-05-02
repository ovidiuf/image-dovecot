FROM alpine

#
# add the operational user 'dovecot'
#

RUN groupadd -g 20500 dovecot && \
    useradd -m -g dovecot -u 20500 dovecot

