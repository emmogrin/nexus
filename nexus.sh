#!/bin/bash

# === COLORS ===
GREEN='\033[0;32m'
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

# === INSTALL RUST IF NOT PRESENT ===
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

# === CHECK & INSTALL GLIBC 2.39 IF NEEDED ===
echo -e "${CYAN}🔍 Checking GLIBC version...${NC}"
GLIBC_VER=$(ldd --version | head -n1 | grep -o '[0-9.]*$')
if [ "$(echo "$GLIBC_VER < 2.39" | bc -l)" -eq 1 ]; then
  echo -e "${YELLOW}⚠️  GLIBC $GLIBC_VER is outdated. Installing 2.39 fallback...${NC}"
  rm -rf ~/glibc-2.39 ~/glibc-2.39.tar.gz
  wget -c https://ftp.gnu.org/gnu/glibc/glibc-2.39.tar.gz
  tar -xzf glibc-2.39.tar.gz && cd glibc-2.39
  mkdir glibc-build && cd glibc-build
  ../configure --prefix=/opt/glibc-2.39
  make -j$(nproc)
  sudo make install
  cd ~
  export LD_LIBRARY_PATH="/opt/glibc-2.39/lib:$LD_LIBRARY_PATH"
  export PATH="/opt/glibc-2.39/lib:$PATH"
fi

# === INSTALL NEXUS CLI ===
echo -e "${CYAN}⚔️ Installing Nexus CLI...${NC}"
curl https://cli.nexus.xyz/ | sh
source ~/.bashrc
export PATH="$HOME/.nexus/bin:$PATH"

# === VERIFY NEXUS INSTALLED ===
if ! command -v nexus-network &> /dev/null; then
  echo -e "${RED}❌ Nexus CLI not found in PATH.${NC}"
  exit 1
fi

# === START PROVER (LET IT HANDLE LOGS) ===
echo -e "${CYAN}▶️ Starting prover with Nexus log UI...${NC}"
exec nexus-network start --node-id "$NODE_ID"
