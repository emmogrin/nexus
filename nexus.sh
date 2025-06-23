#!/bin/bash

# === COLORS ===
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# === BANNER ===
clear
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════╗"
echo "║      🔥 SAINT KHEN BLESSES YOUR PROOFS 🔥     ║"
echo "║       ⚔️  Nexus Prover by @admirkhen ⚔️       ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# === QUOTES ===
slogans=(
  "🧿 Proofs are sacred. Saint Khen watches."
  "⚡ No task fails under divine compute."
  "🔥 This prover runs on blessings and bare metal."
  "⛓ Saint doesn’t sleep. Neither does your node."
)
QUOTE=${slogans[$RANDOM % ${#slogans[@]}]}
echo -e "${YELLOW}$QUOTE${NC}"
echo ""

# === NODE ID ===
read -p "📥 Enter your Node ID: " NODE_ID

# === INSTALL CURL FIRST ===
echo -e "${CYAN}📦 Installing curl first...${NC}"
sudo apt update && sudo apt install curl -y

# === INSTALL DEPS ===
echo -e "${CYAN}🔧 Installing system packages...${NC}"
sudo apt install build-essential pkg-config libssl-dev git protobuf-compiler -y

# === INSTALL RUST ===
if ! command -v cargo &> /dev/null; then
    echo -e "${CYAN}📦 Installing Rust...${NC}"
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    export PATH="$HOME/.cargo/bin:$PATH"
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
else
    echo -e "${GREEN}✔️ Rust already installed.${NC}"
fi

# === ADD RISC TARGET ===
rustup target add riscv32i-unknown-none-elf

# === INSTALL NEXUS CLI ===
echo -e "${CYAN}⚔️ Installing Nexus CLI...${NC}"
curl https://cli.nexus.xyz/ | sh

# Apply updated path manually
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi
export PATH="$HOME/.cargo/bin:$HOME/.nexus/bin:$PATH"

# === VALIDATE INSTALL ===
if ! command -v nexus-network &> /dev/null && [ ! -f "$HOME/.nexus/bin/nexus-network" ]; then
    echo -e "${RED}❌ Nexus CLI installed, but binary not found in path. Try restarting your VPS session.${NC}"
    exit 1
fi

# === LOG FILE ===
LOG_FILE="$HOME/nexus-logs-$(date +%F_%T).log"
echo -e "📜 Saving logs to: ${CYAN}$LOG_FILE${NC}"
echo ""

# === START PROVER ===
nexus-network start --node-id "$NODE_ID" 2>&1 | awk -v green="$GREEN" -v red="$RED" -v yellow="$YELLOW" -v cyan="$CYAN" -v nc="$NC" -v bold="$BOLD" '
{
    timestamp = strftime("[%Y-%m-%d %H:%M:%S]")
    if ($0 ~ /Successfully submitted proof/) {
        print green timestamp " ✅ " $0 nc
    } else if ($0 ~ /Proof completed successfully/) {
        print cyan timestamp " 🧠 " $0 nc
    } else if ($0 ~ /Failed to submit proof/) {
        print red timestamp " ⚠️  " $0 nc
    } else if ($0 ~ /Fetched .* tasks/) {
        print yellow timestamp " 🔄 " $0 nc
    } else {
        print timestamp "  " $0
    }
    fflush()
}' | tee -a "$LOG_FILE"
