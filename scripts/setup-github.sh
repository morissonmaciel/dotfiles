check_github_ssh() {
    if [ ! -f "$HOME/.ssh/id_rsa_github" ]; then
        echo "GitHub SSH key is not found. Please run setup_github_ssh."
    fi
}

check_github_auth() {
    if ! gh auth status &> /dev/null; then
        echo "GitHub CLI authentication is required. Please run setup_github_auth."
    fi
}

check_copilot_extension() {
    if ! gh extension list | grep -q 'gh-copilot'; then
        echo "GitHub Copilot CLI extension is not installed. Please run setup_copilot_extension."
    fi
}

setup_github_ssh() {
  echo -n "Enter your GitHub email: "
  read github_email

  if [ -z "$github_email" ]; then
    echo "GitHub email is required. Exiting..."
    exit 1
  fi

  ssh_key_path="$HOME/.ssh/id_rsa_github"

  if [[ -f "$ssh_key_path" ]]; then
    echo "SSH key already exists at $ssh_key_path"
  else
    ssh-keygen -t rsa -b 4096 -C "$github_email" -f "$ssh_key_path" -N ""
    echo "SSH key generated at $ssh_key_path"
  fi

  eval "$(ssh-agent -s)"
  ssh-add "$ssh_key_path"

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cat "${ssh_key_path}.pub" | xclip -selection clipboard
  else
    pbcopy < "${ssh_key_path}.pub"
  fi

  echo "SSH public key copied to clipboard. Add it to GitHub."
  read -n 1 -s -r -p "Press any key to open GitHub SSH settings..."
  echo ""

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "https://github.com/settings/ssh/new"
  else
    open "https://github.com/settings/ssh/new"
  fi
}

setup_github_auth() {
    if ! command -v gh &> /dev/null; then
        echo "Cannot authenticate GitHub CLI. GitHub CLI is not installed. Install it using the command setup_github_cli."
    fi

    echo "Setup process for Github CLI needs to be completed in the browser using device code authentication."
    echo "Opening the browser for authentication...Check device code in terminal once the browser is opened."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open "https://github.com/login/device"
    else
        open "https://github.com/login/device"
    fi

    echo "Generating a device code for GitHub Copilot CLI..."
    auth_response=$(gh auth login --web --scopes "read:org,repo,workflow")

    if ! gh auth status &> /dev/null; then
        echo "GitHub CLI authentication failed. Please try again using the command setup_github_auth."
    fi
}

setup_copilot_extension() {
    if ! -v gh &> /dev/null; then
        echo "Cannot install GitHub Copilot CLI extension. GitHub CLI is not installed. Install it using the command setup_github_cli."
        exit 1
    elif ! gh auth status &> /dev/null; then
        echo "Cannot install GitHub Copilot CLI extension. GitHub CLI authentication is required. Authenticate using the command setup_github_auth."
        exit 1
    fi

    echo "Installing GitHub Copilot CLI extension..."
    gh extension install github/gh-copilot

    if gh extension list | grep -q 'gh-copilot'; then
        echo "GitHub Copilot CLI setup is complete!"
    else
        echo "Github Copilot extension installation failed. Please try again using the command setup_copilot_extension."
    fi
}

setup_github_cli() {
    local github_cli_not_found=false

    if ! command -v gh &> /dev/null; then
        github_cli_not_found=true
    fi

    if $github_cli_not_found; then
        if ! command -v brew &> /dev/null; then
            echo "Cannot install github cli. Homebrew is not installed."
            exit 1
        fi
        brew install gh
    fi

    if command -v gh &> /dev/null; then
        echo "github cli is installed."
    fi

    setup_github_auth
    setup_github_ssh
    setup_copilot_extension
}

if [ ! command -v gh &> /dev/null ]; then
    echo "github cli is not installed. Install it using the command setup_github_cli."
elif ! gh auth status &> /dev/null; then
    check_github_auth
elif [ ! -f "$HOME/.ssh/id_rsa_github" ]; then
    check_github_ssh
elif ! gh extension list | grep -q 'gh-copilot'; then
    check_copilot_extension
else
    alias copilot="gh copilot"
fi
