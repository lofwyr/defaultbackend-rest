# Default Backend Server

This is a simple webserver that satisfies the ingress, which means it
does the following things:

 1. Serves 404 at `/`
 2. Serves 200 on a `/healthz`
 3. Serves Metrics on a `/metrics`
 4. Serves 404 on `/healthz` and `/metrics` if X-Forwarded-For header is set.

Server responds with empty body


## Example usage:

Kubernetes:
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: default-backend
  labels:
    app: default-backend
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: default-backend
    spec:
      terminationGracePeriodSeconds: 60
      containers:
      - name: default-backend
        image: default-backend:latest
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 30
          timeoutSeconds: 5
        ports:
        - containerPort: 8080
        resources:
          limits:
            cpu: 10m
            memory: 20Mi
          requests:
            cpu: 10m
            memory: 20Mi
---
apiVersion: v1
kind: Service
metadata:
  name: default-backend
  labels:
    app: default-backend
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
  selector:
    app: default-backend
```
