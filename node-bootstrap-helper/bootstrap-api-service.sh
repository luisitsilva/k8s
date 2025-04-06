#/usr/bin/sh

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Searching for package.json"
if [ ! -f package.json ]; then
  echo -e "${YELLOW}No package.json found. Initializing npm project...${NC}"
  npm init -y >/dev/null
fi

echo "Search for npm installation"
if ! command -v npm &> /dev/null; then
  echo -e "${YELLOW}npm is not installed. Installing Node.js and npm...${NC}"
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  apt install nodejs npm
else
  echo -e "${GREEN}npm is already installed.${NC}"
fi

echo "Search for node modules installed"
if [ ! -d node_modules ]; then
  echo -e "${YELLOW}No node_modules directory found. Running npm install to initialize dependencies...${NC}"
  npm install
fi

echo "Fixing dependecies"
check_and_install_module() {
  local module=$1
  if npm list --depth=0 "$module" &>/dev/null; then
    echo -e "${GREEN}Module '$module' is already installed.${NC}"
  else
    echo -e "${YELLOW}Installing module '$module'...${NC}"
    npm install "$module"
  fi
}

check_and_install_module express
check_and_install_module dotenv






npm init -y
npm install express dotenv

