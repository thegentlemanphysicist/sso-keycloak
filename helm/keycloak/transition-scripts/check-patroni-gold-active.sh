#!/bin/bash

NAMESPACE=$1

pwd="$(dirname "$0")"

source "./helpers.sh"


if ! check_kube_context "api-gold-devops-gov-bc-ca"; then
    echo "invalid context"
    exit 1
fi

STATE=$(oc rsh -n ${NAMESPACE} sso-patroni-0 curl -s http://localhost:8008/patroni | jq .state) 

if ${STATE} != "running"
    echo "The gold patroni pods must be running"
    exit 1
fi

#TODO If the connection fails entirely this will default to null, must add a check for the success
STANDBY_CLUSTER=$(oc rsh -n ${NAMESPACE} sso-patroni-0 curl -s http://localhost:8008/config | jq .standby_cluster)

if [ -z ${STANDBY_CLUSTER} ]
    echo "The gold patroni pods must not be in standby mode"
    exit 1
fi