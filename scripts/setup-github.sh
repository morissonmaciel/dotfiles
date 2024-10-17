if ! alias po &>/dev/null; then
    alias po="echo"
    alias pe="echo"
    alias pw="echo"
fi

check_github_ssh() {
    if [ ! -f "$HOME/.ssh/id_rsa_github" ]; then
        pw "GitHub SSH key is not found. Please run setup_github_ssh."
        return 1
    fi

    po "GitHub SSH key is found."
}

check_github_auth() {
    if ! gh auth status &> /dev/null; then
        pw "GitHub CLI authentication is required. Please run setup_github_auth."
        return 1
    fi

    po "GitHub CLI is authenticated."
}

check_copilot_extension() {
    if ! gh extension list | grep -q 'gh-copilot'; then
        pw "GitHub Copilot CLI extension is not installed. Please run setup_copilot_extension."
        return 1
    fi

    po "GitHub Copilot CLI extension is installed."
}

check_github_cli() {
    if ! command -v gh &> /dev/null; then
        pw "GitHub CLI is not installed. Please run setup_github_cli."
        return 1
    fi

    po "GitHub CLI is installed."
}

setup_github_ssh() {
  po -n "Enter your GitHub email: "
  read github_email

  if [ -z "$github_email" ]; then
    pe "GitHub email is required. Exiting..."
    return 1
  fi

  ssh_key_path="$HOME/.ssh/id_rsa_github"

  if [[ -f "$ssh_key_path" ]]; then
    po "SSH key already exists at $ssh_key_path"
  else
    ssh-keygen -t rsa -b 4096 -C "$github_email" -f "$ssh_key_path" -N ""
    po "SSH key generated at $ssh_key_path"
  fi

  eval "$(ssh-agent -s)"
  ssh-add "$ssh_key_path"

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cat "${ssh_key_path}.pub" | xclip -selection clipboard
  else
    pbcopy < "${ssh_key_path}.pub"
  fi

  po "SSH public key copied to clipboard. Add it to GitHub."
  read -n 1 -s -r -p "Press any key to open GitHub SSH settings..."
  po ""

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "https://github.com/settings/ssh/new"
  else
    open "https://github.com/settings/ssh/new"
  fi
}

setup_github_auth() {
    if ! command -v gh &> /dev/null; then
        pe "Cannot authenticate GitHub CLI. GitHub CLI is not installed. Install it using the command setup_github_cli."
        return 1
    fi

    po "Setup process for Github CLI needs to be completed in the browser using device code authentication."
    po "Opening the browser for authentication...Check device code in terminal once the browser is opened."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open "https://github.com/login/device"
    else
        open "https://github.com/login/device"
    fi

    po "Generating a device code for GitHub Copilot CLI..."
    auth_response=$(gh auth login --web --scopes "read:org,repo,workflow")

    if ! gh auth status &> /dev/null; then
        pe "GitHub CLI authentication failed. Please try again using the command setup_github_auth."
        return 1
    fi
}

setup_copilot_extension() {
    if ! -v gh &> /dev/null; then
        pe "Cannot install GitHub Copilot CLI extension. GitHub CLI is not installed. Install it using the command setup_github_cli."
        return 1
    elif ! gh auth status &> /dev/null; then
        pe "Cannot install GitHub Copilot CLI extension. GitHub CLI authentication is required. Authenticate using the command setup_github_auth."
        return 1
    fi

    po "Installing GitHub Copilot CLI extension..."
    gh extension install github/gh-copilot

    if gh extension list | grep -q 'gh-copilot'; then
        po "GitHub Copilot CLI setup is complete!"
    else
        pe "Github Copilot extension installation failed. Please try again using the command setup_copilot_extension."
    fi
}

setup_github_cli() {
    local github_cli_not_found=false

    if ! command -v gh &> /dev/null; then
        github_cli_not_found=true
    fi

    if $github_cli_not_found; then
        if ! command -v brew &> /dev/null; then
            pe "Cannot install github cli. Homebrew is not installed."
            return 1
        fi
        brew install gh
    fi

    if command -v gh &> /dev/null; then
        po "github cli is installed."
    fi

    setup_github_auth
    setup_github_ssh
    setup_copilot_extension
}

if [ -z "$DOTFILES_USER_PROMPT_SETUPS" ] || [ "$DOTFILES_USER_PROMPT_SETUPS" = "NO" ]; then
    exit 0
fi

if [ ! command -v gh &> /dev/null ]; then
    pw "github cli is not installed. Install it using the command setup_github_cli."
elif ! gh auth status &> /dev/null; then
    check_github_auth
elif [ ! -f "$HOME/.ssh/id_rsa_github" ]; then
    check_github_ssh
elif ! gh extension list | grep -q 'gh-copilot'; then
    check_copilot_extension
fi
