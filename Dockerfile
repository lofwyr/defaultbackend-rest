FROM scratch

USER 65534:65534

COPY build/default-backend-linux /default-backend

ENTRYPOINT ["/default-backend"]
