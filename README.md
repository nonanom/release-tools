# release-tools
This Dockerfile will build a Docker container image with common release tools.

Build it like this:
```
docker image build . --tag release-tools
```
Run it like this:
```
docker run -it --entrypoint bash release-tools
```
