# image-dovecot

## Overview

Metadata and operational logic needed to __configure__, __build__ and __operate__ a dovecot container. The image 
contains logic to add users while it is being built, initialize a private key and to self-sign a certificate 
the first time it is used, created required directories, etc.

## Configure and Build the Container

### Add IMAP Users

Add invocations to /opt/.tmp/add-imap-user-to-image in Dockerfile:

````
RUN ... && \
...
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
...
````

Provide appropriate user name, uid and gid, and place the password in a file in ./root/opt/.tmp/.<username>
whose path is then passed to the script with --password-file=... The file will be deleted by the installation
procedure. 

### Build Image

````
it build
````


## Run Container

* Set DOVECOT_LISTEN_ADDRESS (currently 127.0.0.1) and DOVECOT_LISTEN_PORT in environment.

Run the container with the included script:

````
./bin/run
````

The script will create the required NFS volume, if it does not exist already.

## IMAP Client Configuration

* Use a user that was initialized when the image was built (see ./Dockerfile add-imap-user-to-image)
* For the time being, set up a SSH tunnel to the Docker host and forward the tunnel to localhost:$DOVECOT_LISTEN_PORT

  
