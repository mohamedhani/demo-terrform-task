#!/bin/bash
set -x
KEY=$( curl -s $OIDC_ISSUER/.well-known/openid-configuration | jq -r ".jwks_uri" | cut -f 3 -d "/")
echo $KEY
openssl s_client -servername $KEY -showcerts -connect $KEY:443  < /dev/null |  sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p' | tail -n  26 > /tmp/certificate.crt

THUMBPRINT=$(openssl x509 -in /tmp/certificate.crt -fingerprint -noout | tail -n 1 | cut -f 2 -d "=" | tr  -d ":")
aws iam update-open-id-connect-provider-thumbprint --open-id-connect-provider-arn $OIDC_ARN --thumbprint-list $THUMBPRINT 