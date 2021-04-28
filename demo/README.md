# API Demo - Deploys

Setup your cluster with following:

1. Setup registry credentials
1. Metrics Server
1. Privileged PSP and Role
1. Cert Manager
1. Cluster Issuer for Letencrypt CA
1. Contour
1. EFK Stack
1. Prometheus
1. Grafana
1. Jenkins
1. Harbor
1. Point DNS (techtalk.cna-demo.ga) to the LB of Contour (Envoy) Service

You can follow instruction in [Setup Guide](SETUP)

## Create YAMLS


1. Generate deployment yaml

    ```bash
    kubectl create deployment api-demo --image=ghcr.io/yogendra/api-demo:latest --dry-run=client -o yaml > api-demo/01-deployment.yaml
    ```

    1. **create**: Create a resource
    2. **deployment**: Type of resource to create
    3. **api-demo**: Name of the resource
    4. **--image=yogendra/api-demo**: Image to use for this deployment 
    5. **--dry-run=client**: Tells kubectl not do any change only perform a dry run on the client side.
    6. **-o yaml**: Output the config in YAML format

1. Edit the deployment file as per your need. Here is a sample

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: api-demo
      name: api-demo
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: api-demo
      template:
        metadata:
          labels:
            app: api-demo
        spec:
          containers:
            - image: ghcr.io/yogendra/api-demo:latest
              name: api-demo
              ports:
                - name: http
                  protocol: TCP
                  containerPort: 8080
              resources:
                requests:
                  memory: "720Mi"
                  cpu: "500m"
                limits:
                  memory: "2000Mi"
                  cpu: "1000m"
    ```

1. Apply to cluster

    ```bash
    kubectl apply -f api-demo/01-deployment.yaml
    ```

1. Generate service yaml

    ```bash
    kubectl expose deployment api-demo --port 8080 --target-port 8080 --dry-run=client -o yaml > api-demo/02-service.yaml
    ```

1. Edit the service file as per your need. Here is a sample

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: api-demo
    spec:
      type: ClusterIP
      selector:
        app: api-demo
      ports:
        - protocol: TCP
          port: 8080
          targetPort: 8080
          name: http


    ```

1. Apply service

    ```bash
    kubectl apply -f api-demo/02-service.yaml
    ```

1. Create am ingress `api-demo/03-ingress.yaml` file with following content ingress

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: api-demo
      labels:
        app: api-demo
      annotations:
        ingress.kubernetes.io/force-ssl-redirect: "true"
        kubernetes.io/ingress.class: contour
        cert-manager.io/cluster-issuer: letsencrypt-prod
        kubernetes.io/tls-acme: "true"
    spec:
      tls:
        - secretName: api-demo-https-secret
          hosts:
            - api-demo.techtalk.cna-demo.ga
      rules:
        - host: api-demo.techtalk.cna-demo.ga
          http:
            paths:
              - path: / 
                pathType: Prefix
                backend:
                  service:
                    name: api-demo
                    port: 
                        name: http

    ```

1. Apply ingress

    ```bash
    kubectl apply -f api-demo/03-ingress.yaml
    ```

## Helm Chart Demo
