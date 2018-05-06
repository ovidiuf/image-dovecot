# image-dovecot

## Overview

Metadata and operational logic needed to build and operate a dovecot container. The image contains logic to
initialize a private key and to self-sign a certificate the first time it is executed.

## IMAP Client Configuration

* Use a user that was initialized when the image was built (see ./Dockerfile add-imap-user-to-image)
* C

  
