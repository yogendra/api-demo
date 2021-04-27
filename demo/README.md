# API Demo - Deploys

## Create YAMLS

1. Create a deployment directory

    ```bash
    mkdir -p apidemo
    ```

1. Generate deployment yaml

    ```bash
    kubectl create deployment apidemo --image=docker.io/yogendra/api-demo:latest --dry-run=client -o yaml > apidemo/01-apidemo-deployment.yaml
    ```

    1. **create**: Create a resource
    2. **deployment**: Type of resource to create
    3. **apidemo**: Name of the resource
    4. **--image=yogendra/apidemo**: Image to use for this deployment 
    5. **--dry-run=client**: Tells kubectl not do any change only perform a dry run on the client side.
    6. **-o yaml**: Output the config in YAML format

1. Edit the deployment file as per your need. Here is a sample

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: apidemo
      name: apidemo
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: apidemo
      template:
        metadata:
          labels:
            app: apidemo
        spec:
          containers:
            - image: docker.io/yogendra/api-demo:latest
              name: apidemo
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
    kubectl apply -f apidemo/01-apidemo-deployment.yaml
    ```

1. Generate service yaml

    ```bash
    kubectl expose deployment apidemo --port 8080 --target-port 8080 --dry-run=client -o yaml > apidemo/02-apidemo-service.yaml
    ```

1. Edit the service file as per your need. Here is a sample

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: apidemo
    spec:
      type: ClusterIP
      selector:
        app: apidemo
      ports:
        - protocol: TCP
          port: 8080
          targetPort: 8080
          name: http


    ```

1. Apply service

    ```bash
    kubectl apply -f apidemo/02-apidemo-service.yaml
    ```

1. Create am ingress `apidemo/03-apidemo-ingress.yaml` file with following content ingress

    ```yaml
    apiVersion: networking.k8s.io/v1beta1
    kind: Ingress
    metadata:
      name: apidemo
      labels:
        app: apidemo
      annotations:
        ingress.kubernetes.io/force-ssl-redirect: "true"
        kubernetes.io/ingress.class: contour
        cert-manager.io/cluster-issuer: letsencrypt-prod
        kubernetes.io/tls-acme: "true"
    spec:
      tls:
        - secretName: apidemo-https-secret
          hosts:
            - apidemo.techtalk.cna-demo.ga
      rules:
        - host: apidemo.techtalk.cna-demo.ga
          http:
            paths:
              - backend:
                  serviceName: apidemo
                  servicePort: http

    ```

1. Apply ingress

    ```bash
    kubectl apply -f apidemo/03-apidemo-ingress.yaml
    ```

## Deploy with Yaml

```
kubectl apply -f mkdir -p apidemo
```

## Helm Chart Demo
