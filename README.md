# [WIP] Self-hosted Cloud-based Reverse Engineering Lab

self-hosted, cloud-based, browser accessible GUI linux or windows environment with reverse engineering tools like IDA Pro and others installed.

# Preparing IDA

1. Add your hexlic license (`idapro.hexlic`) to the directory you have IDA installed, configure IDA to pull the license from that location
2. Zip up the entire IDA directory, including the license file, and name it `ida.zip`
3. Place `ida.zip` in the same directory as this README

# Linux

## Remote access

```bash
docker buildx build --platform linux/amd64 -f Dockerfile.linux -t ida-linux .

docker run --platform linux/amd64 -d \
  -p 6080:80 \
  -p 5900:5900 \
  -v /dev/shm:/dev/shm \
  --name ida-linux \
  ida-linux
```

## Access
Browser: http://localhost:6080
VNC: localhost:5900

## Secure tunnel access

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

# Windows

## Downloading an ISO

Download a Windows 11 ISO from: https://www.microsoft.com/en-us/software-download/windows11 or if you're on ARM: https://www.microsoft.com/en-us/software-download/windows11arm64

Or a vhdx file from: https://www.microsoft.com/en-us/software-download/windowsinsiderpreviewarm64

Download Windows Virtual Drivers: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.285-1/virtio-win-0.1.285.iso


```bash
qemu-img create -f qcow2 windows11.qcow2 100G

qemu-system-x86_64 \
  -accel hvf \
  -m 8G \
  -cpu host \
  -smp 4 \
  -drive file=windows11.qcow2,format=qcow2 \
  -cdrom Win11_25H2_English_x64_v2.iso \
  -drive file=virtio-win.iso,media=cdrom \
  -boot d \
  -vnc :1

# if on ARM
cp /opt/homebrew/Cellar/qemu/11.0.0/share/qemu/edk2-arm-vars.fd vars.fd
qemu-img create -f qcow2 windows-arm.qcow2 64G
qemu-img convert -O qcow2 Windows11_Arm64.vhdx windows-arm.qcow2
qemu-system-aarch64 \
>   -accel hvf \
>   -cpu host \
>   -machine virt,highmem=on \
>   -m 4096 \
>   -smp 2 \
>   -drive if=pflash,format=raw,readonly=on,file=/opt/homebrew/Cellar/qemu/11.0.
0/share/qemu/edk2-aarch64-code.fd \
>   -drive if=pflash,format=raw,file=vars.fd \
>   -device qemu-xhci \
>   -drive if=none,id=hd0,file=windows-arm.qcow2,format=qcow2 \
>   -device nvme,drive=hd0,serial=nvme0 \
>   -device ramfb \
>   -device usb-kbd \
>   -device usb-tablet \
>   -device e1000,netdev=net0 \
>   -netdev user,id=net0 \
>   -vnc :1,password=on \
>   -monitor tcp:127.0.0.1:4444,server,nowait

nc localhost 4444
change vnc password
# enter password

open vnc://localhost:5901

# to setup network, press fn+shift+f10 then type
taskkill /F /IM oobenetworkconnectionflow.exe
# this will allow you to continue setup without network drivers initially
```