# image-dovecot

## Overview

Metadata and operational logic needed to build and operate a dovecot container. 

## To Run

* In the external storage point, create a 'ssl' directory. Inside the 'ssl' directory
  create ./ssl/certs and ./ssl/private. Place a ./ssl/certs/dovecot-pub.pem and a 
  ./ssl/private/dovecot-private.pem
  
```
cd ssl
openssl genrsa -out ./private/dovecot-private.pem 2048
chmod -R go-rwx ./private
openssl rsa -pubout -in ./private/dovecot-private.pem -out ./certs/dovecot-pub.pem
``` 
    
   
