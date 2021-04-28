# Setup Cluster

1. Patch Service Account with Docker credentials

    ```bash
    script/add-image-pull-credentials.sh    
    ```

    *Sample Output*

    ```bash
    Docker registry credential name (used for secret object name): ghcr
    Service acount to patch: default
    Docker Registry Server (Example: ghcr.io, docker.io, harbor.mycluster.com): ghcr.io
    Docker Registry Username : yogendra
    Docker Registry User Email : yogendrarampuria@gmail.com
    Docker Registry Password : 
    Creating ghcr for docker registry ghcr.io
    secret/ghcr created
    serviceaccount/default patched
    ```

1. Allow privileged/run as root containers containers

    ```bash
    kubectl create clusterrolebinding privileged-cluster-role-binding \
        --clusterrole=vmware-system-privileged \
        --group=system:authenticated
    ```

1. Create a privileged PSP

    ```bash
    kubectl apply -f setup/privileged-psp.yaml
    ```

1. Install Metrics Server

    ```bash
    kubectl apply -f setup/metrics-server.yaml
    ```

1. Install cert-manager

    ```bash
    kubectl apply -f  setup/cert-manager.yaml
    ```

    1. Install lets encrypt issuers

        ```bash
        kubectl apply -f setup/letsencrypt.yaml
        ```

1. Install contour

    ```bash
    kubectl apply -f setup/contour.yaml
    ```

    1. Update DNS record

        ```bash
        AWS_HOSTED_ZONE_ID=Z05688932VSDMPEHGAGKB
        CLUSTER_INGRESS_DOMAIN=techtalk.cna-demo.ga
        script/update-route53.sh $AWS_HOSTED_ZONE_ID $CLUSTER_INGRESS_DOMAIN
        ```

1. Install Harbor

    1. Add Helm repository

        ```bash
        helm repo add harbor https://helm.goharbor.io
        ```

    1. Create namespace

        ```bash
        kubectl create ns harbor
        ```

    1. Install harbor with helm chart

        ```bash
        helm install registry harbor/harbor -f setup/harbor.yaml -n harbor
        ```

1. Install EFK

    1. Install Elastic Operator

        ```bash
        kubectl apply -f setup/elastic-operator.yaml
        ```

    1. Check status of elastic operator

        ```bash
        kubectl -n elastic-system logs -f statefulset.apps/elastic-operator
        ```

    1. Create Elastic and Kibana deployments

        ```bash
        kubectl apply -f setup/elastic.yaml
        ```

    1. Get elastic password

        *mac copy*

        ```bash
        kubectl get secret logging-es-elastic-user -o go-template='{{.data.elastic | base64decode}}' | pbcopy        
        ```

         *bash*

        ```bash
        PASSWORD=$(kubectl get secret logging-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
        ```

        *fish*

        ```bash
        PASSWORD=(kubectl get secret logging-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
        ```

    1. Quick test elastic

        ```bash
        curl -u "elastic:$PASSWORD" https://logs.techtalk.cna-demo.ga"        
        ```

        *Output:*

        ```json
        {
            "name" : "logging-es-default-0",
            "cluster_name" : "logging",
            "cluster_uuid" : "WjC0eysITUq9qHSscPdlPw",
            "version" : {
                "number" : "7.12.1",
                "build_flavor" : "default",
                "build_type" : "docker",
                "build_hash" : "3186837139b9c6b6d23c3200870651f10d3343b7",
                "build_date" : "2021-04-20T20:56:39.040728659Z",
                "build_snapshot" : false,
                "lucene_version" : "8.8.0",
                "minimum_wire_compatibility_version" : "6.8.0",
                "minimum_index_compatibility_version" : "6.0.0-beta1"
            },
            "tagline" : "You Know, for Search"
        }
        ```

    1. Quick test Kibana

    

All Set! Goto [Demo Guide](README)
