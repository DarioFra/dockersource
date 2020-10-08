## Table of contents
* [General info](#general-info)
* [mbsync](#mbsync)
** [Technologies](#mbsynctech)
** [Build](#mbsyncbuild)
** [Running](#mbsyncrunning)
* [proxy](#proxy)
** [Technologies](#proxytech)
** [Build](#proxybuild)
** [Running](#proxyrunning)

## General info <a name="general-info"></a>
A collection of docker source files for build and or docker-compose

## mbsync <a name="mbsync"></a>
A packaging of https://isync.sourceforge.io/ mdsync (imap/pop synch of mailboxes) using an openssl version OpenSSL 1.1.1g  21 Apr 2020
which seems to work with both newer crypos and older (unsafe) cryptos (good if you are sunsetting some old server)

### Technologies <a name="mbsynctech"></a>
Project is created with:
* apline linux (OpenSSL 1.1.1g)
* mdsync

### Build <a name="mbsyncbuild"></a>

```
docker build . -t dariofr/mbsync:v1.0
```

### Running <a name="mbsyncrunning"></a>
Create docker-compose.yml file in /mbsync ( you can change folder ) as below
add or remove the extra_hosts section (only needed if you need to override DNS)
```
version: '3.8'

services:

  # Core service
  mbsync:
    image: mbsync
    restart: always
    volumes:
      - "/mbsync/root:/root"
    extra_hosts:
     - "mail.somehost.se:192.168.8.201"
     - "mail.someother.se:192.168.8.115"
    command: /bin/bash --init-file /mbinit.sh

```
docker-compose run mbsync
Will take you to the bash prompt.
Update the /mbsync/root/.mbsyncrc file
run
```
mbsync my-channel
```

## proxy <a name="proxy"></a>
### Technologies <a name="proxytech"></a>
proxy setup with nginx
### Build <a name="proxybuild"></a>
### Running <a name="proxyrunning"></a>
