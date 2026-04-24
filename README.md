# Self-hosted Cloud-based Reverse Engineering Lab

self-hosted, cloud-based, browser accessible GUI linux environment with reverse engineering tools like IDA Pro and others installed.

# Preparing IDA

1. Add your hexlic license (`idapro.hexlic`) to the directory you have IDA installed, configure IDA to pull the license from that location
2. Zip up the entire IDA directory, including the license file, and name it `ida.zip`
3. Place `ida.zip` in the same directory as this README

# Remote access

```bash
docker buildx build --platform linux/amd64 -f Dockerfile.linux -t ida-linux .

docker run --platform linux/amd64 -d \
  -p 6080:80 \
  -p 5900:5900 \
  -v /dev/shm:/dev/shm \
  --name ida-linux \
  ida-linux
```

# Access
Browser: http://localhost:6080
VNC: localhost:5900

# Secure tunnel access

```bash
# on remote host
docker run --platform linux/amd64 -d \
  -p 127.0.0.1:6080:80 \
  -v /dev/shm:/dev/shm \
  --name ida-linux \
  ida-linux

# on local machine
ssh -L 6080:localhost:6080 user@remote_host

# then access http://localhost:6080 in your browser
```