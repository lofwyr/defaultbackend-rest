# Default Backend Server

This is a simple webserver that satisfies the ingress, which means it has to do two things:

 1. Serves a 404 page at `/`
 2. Serves 200 on a `/healthz`

Server respond JSON instead of plain text

Not found page:
```
$ curl http://localhost:8080
{"code":404,"message":"Not found"}
```

Status page:
```
$ curl http://localhost:8080/healthz
{"status":"ok"}
```

## Why?!

In my projects, it's important that alive server respond JSON, even if this is default backend server

Example usage:
```
apiVersion: v1
kind: ReplicationController
metadata:
  name: default-http-backend
spec:
  replicas: 1
  selector:
    app: default-http-backend
  template:
    metadata:
      labels:
        app: default-http-backend
    spec:
      terminationGracePeriodSeconds: 60
      containers:
      - name: default-http-backend
        image: stiks/defaultbackend-rest:1.0
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
```

```
$ kubectl create -f default-backend.yaml
replicationcontroller "default-http-backend" created
```

