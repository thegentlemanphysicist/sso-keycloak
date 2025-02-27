#!/bin/bash

helm repo add sso-charts https://bcgov.github.io/sso-helm-charts
helm repo update

helm upgrade --install sso-keycloak sso-charts/sso-keycloak -n c6af30-test -f values-gold-c6af30-test.yaml --version v1.7.1
