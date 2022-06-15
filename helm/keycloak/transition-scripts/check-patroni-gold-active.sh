#!/bin/bash

NAMESPACE=$1

pwd="$(dirname "$0")"

source "./helpers.sh"


if ! check_kube_context "api-gold-devops-gov-bc-ca"; then
    echo "invalid context"
    exit 1
fi

OUTPUT=$(kubectl -n  ${NAMESPACE} exec sso-patroni-0 -- curl -s http://localhost:8008/patroni)

# STATE=$(oc rsh -n ${NAMESPACE} sso-patroni-0 curl -s http://localhost:8008/patroni | jq .state) 
# echo ${fromJSON(OUTPUT)}
STATE = $(echo ${OUTPUT} | jq '.state')
echo "The state is ${STATE}"

# if [${STATE} != "running"]; then
#     echo "The gold patroni pods must be running"
#     exit 1
# fi

#TODO If the connection fails entirely this will default to null, must add a check for the success
GOLDCONFIG=$(kubectl -n  ${NAMESPACE} exec sso-patroni-0 -- curl -s http://localhost:8008/config)
echo ${GOLDCONFIG}
STANDBY_CLUSTER = ${GOLDCONFIG} | jq .standby_cluster
# if [ -z ${STANDBY_CLUSTER} ]; then
#     echo "The gold patroni pods must not be in standby mode"
#     exit 1
# fi

#TODO: Check that the TSC service is running?


# kubectl -n c6af30-test exec sso-patroni-0 -- curl -s http://localhost:8008/config | jq .