#!/bin/bash
# Todo, make this general for all namespaces

NAMESPACE=""

pwd="$(dirname "$0")"
source "./helm/helpers.sh"
# TODO fix this context
# if ! check_kube_context "api-golddr-devops-gov-bc-ca"; then
#     echo "invalid context"
#     exit 1
# fi

helm repo add sso-charts https://bcgov.github.io/sso-helm-charts
helm repo update

cd ./helm/keycloak/

helm upgrade --install sso-keycloak sso-charts/sso-keycloak \
 -n ${NAMESPACE} -f ./values-golddr-${NAMESPACE}.yaml  \
 -f ./transition-values/set-dr-to-active-${NAMESPACE}.yaml --version v1.6.0

# helm repo add sso-charts https://bcgov.github.io/sso-helm-charts
# helm repo update



# helm upgrade --install sso-keycloak sso-charts/sso-keycloak -n ${NAMESPACE} -f ./helm/keycloak/values-gold-${NAMESPACE}.yaml --version v1.2.1
