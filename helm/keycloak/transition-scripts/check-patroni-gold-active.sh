#!/bin/bash

NAMESPACE=$1

pwd="$(dirname "$0")"

source "./helpers.sh"


if ! check_kube_context "api-gold-devops-gov-bc-ca"; then
    echo "invalid context"
    exit 1
fi


OUTPUT=$(kubectl -n  ${NAMESPACE} exec sso-patroni-0 -- curl -s http://localhost:8008/patroni)

STATE=$(echo $OUTPUT | jq '.state')

if [[ $STATE == '"running"' ]]; then
    echo "The gold patroni pod is running"
else
    echo "The gold patroni pods must be running"
    exit 1
fi

#TODO If the connection fails entirely this will default to null, must add a check for the success
RESPONSE=$(kubectl -n ${NAMESPACE} exec sso-patroni-0 -- curl -s -w "%{http_code}" http://localhost:8008/config)

RESPONSE_CODE=${OUTPUT: -4}
GOLDCONFIG=${OUTPUT:0:-3}
# GOLDCONFIG=$(kubectl -n  ${NAMESPACE} exec sso-patroni-0 -- curl -s http://localhost:8008/config)
echo ${GOLDCONFIG}
STANDBY_CLUSTER=$(echo $GOLDCONFIG | jq .standby_cluster )


if [ $RESPONSE != 200 ]; then
    echo "The gold patroni pods did not return a 200 response"
    exit 1
else
    echo "Patroni config response returned"
fi

if [ -z ${STANDBY_CLUSTER} ]; then
    echo "The gold patroni pods must not be in standby mode"
    exit 1
else 
    echo "Patroni config in active mode"
fi

#TODO: Check that the TSC service is running?
