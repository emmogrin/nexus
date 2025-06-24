
# ⚔️ Nexus Prover - Blessed by Saint Khen

This script sets up and runs a Nexus prover node with just one command.  

> “😴 Let it prove while you sleep. Saint Khen watches.” — [@admirkhen](https://twitter.com/admirkhen)

---

## ⚙️ Requirements

- Ubuntu VPS (20.04 / 22.04)
- Minimum **8GB RAM**, **4+ vCPUs**
- Root access (`sudo`)

---

## 🚀 1-Line Install

```bash
git clone https://github.com/emmogrin/nexus.git
cd nexus
chmod +x nexus.sh
./nexus.sh
```
This will:

Install all dependencies (Rust, build tools, curl, etc)

Install Nexus CLI

Prompt you for your Node ID

Start the prover in a background screen session

# ⚠️ For Ubuntu < 24.04.1 or GLIBC < 2.39

Use this if your system is older or running in QEMU (Docker must be installed):
```
git clone https://github.com/emmogrin/nexus.git && cd nexus && chmod +x nexus-docker.sh && ./nexus-docker.sh
```
or

```
git clone https://github.com/emmogrin/nexus.git
cd nexus
chmod +x nexus-docker.sh
./nexus-docker.sh
```

# To restart or run after reboot or maybe it closed down.
```
cd nexus
```
```
source ~/.bashrc
```
replace your YOUR_NODE_ID with your actual node id
```
nexus-network start --node-id YOUR_NODE_ID
````
---

👣 Manual Steps (needed)

1. Visit: https://app.nexus.xyz/nodes


2. Click Add Node → Add CLI Node


3. Copy your node-id when prompted by the script




---

🧪 Monitoring

Once started, your prover runs inside a screen:

Reattach: screen -r nexus-prover

Detach: Ctrl + A, then press D

Stop it: screen -XS nexus-prover quit



---

💬 Support

Built and blessed by @admirkhen
For updates or issues, DM on Twitter or open a GitHub issue.


---

🙏 Credits

Nexus CLI: nexus.xyz

Log styling, setup magic, and chaos: Saint Khen 🛐
# nexus
