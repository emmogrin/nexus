#!/bin/bash

# === COLORS ===
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# === SAINT KHEN BANNER ===
clear
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════╗"
echo "║      🔥 SAINT KHEN BLESSES YOUR PROOFS 🔥     ║"
echo "║       ⚔️  Nexus Prover by @admirkhen ⚔️       ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# === RANDOM QUOTE ===
quotes=(
  "🧿 Proofs are sacred. Saint Khen watches."
  "⚡ No task fails under divine compute."
  "🔥 This prover runs on blessings and bare metal."
  "⛓ Saint doesn’t sleep. Neither does your node."
)
QUOTE=${quotes[$RANDOM % ${#quotes[@]}]}
echo -e "${YELLOW}$QUOTE${NC}"
echo ""

# === ASK FOR NODE ID ===
read -p "📥 Enter your Node ID: " NODE_ID

# === RUN THE CONTAINER ===
docker run -it --rm coinking1/nexus-prover start --node-id "$NODE_ID"
