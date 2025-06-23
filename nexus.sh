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

# === INSTALL CURL + DEPS ===
echo -e "${CYAN}📦 Installing dependencies...${NC}"
sudo apt update
sudo apt install -y curl build-essential pkg-config libssl-dev git protobuf-compiler gawk bison make wget tar

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

# === RISC TARGET ===
rustup target add riscv32i-unknown-none-elf

# === INSTALL NEXUS CLI ===
echo -e "${CYAN}⚔️ Installing Nexus CLI...${NC}"
curl https://cli.nexus.xyz/ | sh
source "$HOME/.bashrc"
export PATH="$HOME/.cargo/bin:$HOME/.nexus/bin:$PATH"

# === CHECK + FIX GLIBC ===
echo -e "${CYAN}🔍 Checking GLIBC version...${NC}"
GLIBC_VER=$(ldd --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
NEXUS_PATH="$HOME/.nexus/bin/nexus-network"

if [[ $(echo "$GLIBC_VER < 2.39" | bc -l) == 1 ]]; then
    echo -e "${YELLOW}⚠️ GLIBC version is $GLIBC_VER — patching to 2.39...${NC}"
    cd ~
    wget -nc https://ftp.gnu.org/gnu/glibc/glibc-2.39.tar.gz
    tar -xzf glibc-2.39.tar.gz
    cd glibc-2.39
    mkdir -p build && cd build
    ../configure --prefix=/opt/glibc-2.39
    make -j$(nproc)
    sudo make install

    # === Set fallback runner ===
    export GLIBC_RUNNER="/opt/glibc-2.39/lib/ld-linux-x86-64.so.2"
    export LIBS="/opt/glibc-2.39/lib:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu"
    RUN_CMD="$GLIBC_RUNNER --library-path $LIBS $NEXUS_PATH"
else
    echo -e "${GREEN}✔️ GLIBC $GLIBC_VER is fine.${NC}"
    RUN_CMD="nexus-network"
fi

# === FINAL CHECK ===
if [ ! -x "$NEXUS_PATH" ]; then
    echo -e "${RED}❌ nexus-network binary not found. Installation failed.${NC}"
    exit 1
fi

# === LOGS ===
LOG_FILE="$HOME/nexus-logs-$(date +%F_%T).log"
echo -e "📜 Logging to: ${CYAN}$LOG_FILE${NC}"

# === START PROVER ===
$RUN_CMD start --node-id "$NODE_ID" 2>&1 | awk -v green="$GREEN" -v red="$RED" -v yellow="$YELLOW" -v cyan="$CYAN" -v nc="$NC" '
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
