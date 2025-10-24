# Pull a lightweight base image
FROM alpine:latest

# Run a simple command when the container starts
CMD ["echo", "Hello, Docker!"]