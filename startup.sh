#!/bin/bash
[[ "TRACE" ]] && set -x

: ${KERB_ADMIN_USER:=admin}
: ${KERB_ADMIN_PASS:=admin}
: ${KERB_HTTP_SERVICE_NAME:=localhost}
: ${START_COMMAND:='npm run start'}
: ${KERB_ADMIN_ADDRESS:=NULL}

if [ ! -z $KERB_ADMIN_ADDRESS ] ; then
  /wait-for-it.sh ${KERB_ADMIN_ADDRESS} -- echo "Connection established with Kerberos Admin server"
fi

set_kerberos_principal() {
# Retrieve Kerberos principal keytab file and login with it
  kadmin -p ${KERB_ADMIN_USER} -q "addprinc -randkey HTTP/${KERB_HTTP_SERVICE_NAME}" <<EOF
$KERB_ADMIN_PASS
$KERB_ADMIN_PASS
EOF
  kadmin -p ${KERB_ADMIN_USER} -q "ktadd HTTP/${KERB_HTTP_SERVICE_NAME}" <<EOF
$KERB_ADMIN_PASS
$KERB_ADMIN_PASS
EOF
  kinit -k HTTP/${KERB_HTTP_SERVICE_NAME}

  # Check successful kinit
  klist
}

if [ ! -f /krb5_client_initialized ] ; then
  set_kerberos_principal
  
  touch /krb5_client_initialized
fi

# Start application
eval $START_COMMAND