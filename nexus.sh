#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

# === BANNER ===
clear
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════╗"
echo "║      🔥 SAINT KHEN BLESSES YOUR PROOFS 🔥     ║"
echo "║       ⚔️  Nexus Prover by @admirkhen ⚔️       ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"
sleep 1

echo -e "${GREEN}==> Updating system...${NC}"
sudo apt update && sudo apt upgrade -y

echo -e "${GREEN}==> Installing dependencies...${NC}"
sudo apt install screen curl build-essential pkg-config libssl-dev git-all protobuf-compiler -y

echo -e "${GREEN}==> Installing Rust...${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

echo -e "${GREEN}==> Adding riscv32 target...${NC}"
rustup target add riscv32i-unknown-none-elf

echo -e "${GREEN}==> Installing Nexus CLI...${NC}"
curl https://cli.nexus.xyz/ | sh

echo -e "${GREEN}==> Setup complete!${NC}"
echo ""
echo -e "${GREEN}👉 NOW DO THIS:${NC}"
echo "1. Visit: https://app.nexus.xyz/nodes"
echo "2. Click 'Add Node' → 'Add CLI Node'"
echo "3. Copy your node ID"
echo ""

read -p "📥 Paste your Node ID here: " NODE_ID

echo -e "${GREEN}==> Starting Nexus prover in screen...${NC}"
sleep 1

screen -S nexus-prover bash -c "source ~/.bashrc && nexus-network start --node-id $NODE_ID"

echo ""
echo -e "${GREEN}✔️ Node is running inside screen 'nexus-prover'${NC}"
echo "👉 To reattach: screen -r nexus-prover"
echo "👉 To detach: Ctrl+A then D"
echo ""
echo -e "${GREEN}😴 Let it prove while you sleep. Saint Khen watches.${NC}"
