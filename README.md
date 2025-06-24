# ⚔️ Nexus Prover — Blessed by Saint Khen

This script sets up and runs a Nexus prover node with just one command — optimized for QEMU, VPS, and even older Ubuntu systems.

> 🛐 “Let it prove while you sleep. Saint Khen watches.” @admirkhen




---

⚙️ Requirements

Ubuntu 20.04 / 22.04 VPS or QEMU setup

8GB+ RAM, 4+ vCPUs

Root access (sudo)

⚠️ Docker installed (for fallback script below)



---

🚀 One-Click Setup (Systemd-Compatible Systems)
```
git clone https://github.com/emmogrin/nexus.git
cd nexus
chmod +x nexus.sh
./nexus.sh
```
This will:

Install dependencies (Rust, build tools, etc)

Install Nexus CLI

Prompt you for your Node ID

Start the prover in a background screen session




---

# ⚠️ If You're On Ubuntu < 24.04.1 or GLIBC < 2.39

Use this Docker-based script if:

You're on older systems like Ubuntu 20.04 / QEMU

Your GLIBC version is below 2.39


🔍 How to check:
# Check Ubuntu version
```
lsb_release -a
```
# Check GLIBC version (look at the first line)
```
ldd --version      
```
If your GLIBC version is lower than 2.39, use the fallback:
```
git clone https://github.com/emmogrin/nexus.git
cd nexus
chmod +x nexus-docker.sh
./nexus-docker.sh
```
> ⚠️ Docker must be installed
Confirm with:
```
docker --version
```



🔁 Restarting After Reboot

If your VPS or QEMU is restarted:

cd nexus
source ~/.bashrc
nexus-network start --node-id YOUR_NODE_ID

Replace YOUR_NODE_ID with the one from https://app.nexus.xyz/nodes



👣 Manual Setup (Once)

1. Go to: https://app.nexus.xyz/nodes

2. Click Add Node → Add CLI Node

3. Copy your Node ID when prompted by the script





🧪 Monitoring Logs

If using screen version:

Reattach: screen -r nexus-prover

Detach: Ctrl + A, then press D

Stop: screen -XS nexus-prover quit


If using Docker version:

Logs:
```
docker logs -f nexus-prover
```
or (change YOUR_NODE_ID to your actual id and paste)
```
docker run -it --rm coinking1/nexus-prover start --node-id YOUR_NODE_ID
```
Stop: 
```
docker stop nexus-prover
```
Remove: 
```
docker rm nexus-prover
```


---

💬 Support

Built and blessed by @admirkhen
For help, DM on Twitter or open a GitHub issue.


---

🙏 Credits

Nexus CLI: nexus.xyz

Scripted & stylized by Saint Khen 🛐

Designed for all — from mobile QEMU to cloud VPS warriors

