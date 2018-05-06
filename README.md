# image-dovecot

## Overview

Metadata and operational logic needed to build and operate a dovecot container. The image contains logic to
initialize a private key and to self-sign a certificate the first time it is executed.

## Run Container

* Set DOVECOT_LISTEN_ADDRESS (currently 127.0.0.1) and DOVECOT_LISTEN_PORT in environment.
* Mount the external storage directory on /nfs/dovecot on the Docker host

Then run the container with the included script:

````
./bin/run
````

## IMAP Client Configuration

* Use a user that was initialized when the image was built (see ./Dockerfile add-imap-user-to-image)
* For the time being, set up a SSH tunnel to the Docker host and forward the tunnel to localhost:$DOVECOT_LISTEN_PORT

  
