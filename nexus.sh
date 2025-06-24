#!/bin/bash

# === COLORS ===
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
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
quotes=(
  "🧿 Proofs are sacred. Saint Khen watches."
  "⚡ No task fails under divine compute."
  "🔥 This prover runs on blessings and bare metal."
  "⛓ Saint doesn’t sleep. Neither does your node."
)
QUOTE=${quotes[$RANDOM % ${#quotes[@]}]}
echo -e "${YELLOW}$QUOTE${NC}"
echo ""

# === PROMPT NODE ID ===
read -p "📥 Enter your Node ID: " NODE_ID

# === INSTALL DEPENDENCIES ===
echo -e "${CYAN}📦 Installing system dependencies...${NC}"
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

# === GLIBC CHECK ===
echo -e "${CYAN}🔍 Checking GLIBC version...${NC}"
GLIBC_VER=$(ldd --version | head -n1 | grep -o '[0-9.]*$')

# Default to system GLIBC
GLIBC_OK=1
FALLBACK_LD=""
NEXUS_BIN=""

if [ "$(echo "$GLIBC_VER < 2.39" | bc -l)" -eq 1 ]; then
  echo -e "${YELLOW}⚠️  System GLIBC ($GLIBC_VER) is too old. Installing GLIBC 2.39...${NC}"
  rm -rf ~/glibc-2.39 ~/glibc-2.39.tar.gz
  wget -c https://ftp.gnu.org/gnu/glibc/glibc-2.39.tar.gz
  tar -xzf glibc-2.39.tar.gz && cd glibc-2.39
  mkdir glibc-build && cd glibc-build
  ../configure --prefix=/opt/glibc-2.39
  make -j$(nproc)
  sudo make install
  cd ~

  GLIBC_OK=0
  FALLBACK_LD="/opt/glibc-2.39/lib/ld-2.39.so"
  export LD_LIBRARY_PATH="/opt/glibc-2.39/lib:$LD_LIBRARY_PATH"
  echo 'export LD_LIBRARY_PATH="/opt/glibc-2.39/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc
fi

# === INSTALL NEXUS CLI ===
echo -e "${CYAN}⚔️ Installing Nexus CLI...${NC}"
curl https://cli.nexus.xyz/ | sh
source ~/.bashrc
export PATH="$HOME/.nexus/bin:$PATH"

# Confirm actual nexus binary path
if [ -f "$HOME/.nexus/bin/nexus-network" ]; then
  NEXUS_BIN="$HOME/.nexus/bin/nexus-network"
else
  echo -e "${RED}❌ Nexus CLI not found.${NC}"
  exit 1
fi

# === RUN NEXUS ===
echo -e "${CYAN}▶️ Starting Nexus Prover...${NC}"
echo ""

if [ "$GLIBC_OK" -eq 0 ]; then
  echo -e "${YELLOW}⚙️  Using fallback GLIBC 2.39 loader to bypass system restrictions...${NC}"
  exec "$FALLBACK_LD" --library-path /opt/glibc-2.39/lib:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu "$NEXUS_BIN" start --node-id "$NODE_ID"
else
  exec nexus-network start --node-id "$NODE_ID"
fi
