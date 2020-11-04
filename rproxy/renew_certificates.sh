#!/bin/bash
RPROXY_COMPOSE=/root/docker/dockersource/rproxy/docker-compose.yml
MAILU_COMPOSE=/mailu/docker-compose.yml
RPROXY_CERT=/rproxy/data/certbot/conf/live/codebee.se/fullchain.pem
RPROXY_KEY=/rproxy/data/certbot/conf/live/codebee.se/privkey.pem
MAILU_CERT=/mailu/certs/cert.pem
MAILU_KEY=/mailu/certs/key.pem

function log(){
  echo -e "$*"
}
#Check timestamp of cert before calling renew
IFS=' '
read -ra TS <<< $(ls -l --time-style="+%Y-%m-%d:%H:%M:%S" $RPROXY_CERT)
log "Cert last renewed ${TS[5]}"
start=$SECONDS
log "Check if we can renew now"
CBOUT=$(docker-compose -f $RPROXY_COMPOSE run certbot)
log $CBOUT
duration=$(( SECONDS - start ))
log "Cert renew check run took $duration seconds "

read -ra TSA <<< $(ls -l --time-style="+%Y-%m-%d:%H:%M:%S" $RPROXY_CERT)
if [[ "$TS" != "$TSA" ]]; then
  log "Cert renewed, copy files to mailu"
  /bin/cp -f "$RPROXY_CERT" "$MAILU_CERT"
  /bin/cp -f "$RPROXY_KEY" "$MAILU_KEY"
  CBOUT=$(docker-compose -f $RPROXY_COMPOSE exec rproxy /bin/sh -c "kill -HUP \$(cat /var/run/nginx.pid);echo $?")
  log "Reload rproxy result = $CBOUT"
  CBOUT=$(docker-compose -f $MAILU_COMPOSE exec front /bin/sh -c "kill -HUP \$(cat /var/run/nginx.pid);echo $?")
  log "Reload mailu front result = $CBOUT"
else
  log "No certs expired this run "
fi
