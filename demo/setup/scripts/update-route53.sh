#!/usr/bin/env bash

SCRIPT_ROOT=$( cd `dirname $0`; pwd)
AWS_HOSTED_ZONE_ID=${1?"Hosted Zone ID Missing"}
CLUSTER_INGRESS_DOMAIN=${2?"Ingress FQDN Hostname Missing"}

set -e 
LB=$(kubectl get svc -n projectcontour envoy -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
echo "Configure Route53 ($AWS_HOSTED_ZONE_ID): $CLUSTER_INGRESS_DOMAIN -> $LB"
cat <<EOF > dns.json
{
  "Comment": "Updating ${CLUSTER_INGRESS_DOMAIN},*.${CLUSTER_INGRESS_DOMAIN} to ${LB}",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "${CLUSTER_INGRESS_DOMAIN}",
        "Type": "CNAME",
        "TTL": 10,
        "ResourceRecords": [
          {
            "Value": "${LB}"
          }
        ]
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "*.${CLUSTER_INGRESS_DOMAIN}",
        "Type": "CNAME",
        "TTL": 10,
        "ResourceRecords": [
          {
            "Value": "${LB}"
          }
        ]
      }
    }

  ]
}
EOF

aws route53 change-resource-record-sets --hosted-zone-id=${AWS_HOSTED_ZONE_ID} --change-batch file://dns.json

rm dns.json
