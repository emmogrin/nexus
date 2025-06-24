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

# === INSTALL BASE DEPS ===
echo -e "${CYAN}📦 Installing dependencies...${NC}"
sudo apt update && sudo apt install -y build-essential pkg-config libssl-dev git protobuf-compiler curl bc gawk bison gcc make wget tar

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

# === CHECK GLIBC ===
echo -e "${CYAN}🔍 Checking GLIBC version...${NC}"
GLIBC_VER=$(ldd --version | head -n1 | grep -o '[0-9.]*$')
if [ "$(echo "$GLIBC_VER < 2.39" | bc -l)" -eq 1 ]; then
  echo -e "${YELLOW}⚠️  GLIBC $GLIBC_VER is too old. Installing 2.39 fallback...${NC}"
  rm -rf ~/glibc-2.39 ~/glibc-2.39.tar.gz
  wget -c https://ftp.gnu.org/gnu/glibc/glibc-2.39.tar.gz
  tar -xzf glibc-2.39.tar.gz && cd glibc-2.39
  mkdir glibc-build && cd glibc-build
  ../configure --prefix=/opt/glibc-2.39
  make -j$(nproc)
  sudo make install
  cd ~
  GLIBC_PATH="/opt/glibc-2.39/lib"
  GLIBC_RUNNER="/opt/glibc-2.39/lib/ld-linux-x86-64.so.2"
else
  echo -e "${GREEN}✔️ GLIBC $GLIBC_VER is sufficient.${NC}"
  GLIBC_PATH=""
  GLIBC_RUNNER=""
fi

# === INSTALL NEXUS CLI ===
echo -e "${CYAN}⚔️ Installing Nexus CLI...${NC}"
curl https://cli.nexus.xyz/ | sh

source ~/.bashrc
export PATH="$HOME/.nexus/bin:$PATH"

# === VALIDATE NEXUS ===
NEXUS_BIN=$(command -v nexus-network || echo "$HOME/.nexus/bin/nexus-network")
if [ ! -x "$NEXUS_BIN" ]; then
  echo -e "${RED}❌ Nexus CLI not installed or not found in PATH.${NC}"
  exit 1
fi

# === LOG FILE ===
LOG_FILE="$HOME/nexus-logs-$(date +%F_%T).log"
echo -e "📜 Logging to: ${CYAN}$LOG_FILE${NC}"

# === RUN ===
echo -e "${CYAN}▶️ Starting prover...${NC}"
if [ -n "$GLIBC_PATH" ]; then
  CMD="$GLIBC_RUNNER --library-path $GLIBC_PATH:$LD_LIBRARY_PATH $NEXUS_BIN start --node-id $NODE_ID"
else
  CMD="$NEXUS_BIN start --node-id $NODE_ID"
fi

eval $CMD 2>&1 | tee -a "$LOG_FILE"

echo -e "${GREEN}✔️ Nexus prover started!${NC}"
echo -e "${YELLOW}💤 Let it prove while you sleep...${NC}"
echo -e "${CYAN}To monitor logs: tail -f $LOG_FILE${NC}"
