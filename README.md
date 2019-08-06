# ansible-docker
This Dockerfile will build a Docker container image with Ansible.

Build it like this:
```
docker image build . --tag ansible-docker
```
Run it like this:
```
docker run -it --name ansible-docker ansible-docker
```
