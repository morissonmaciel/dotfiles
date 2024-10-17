setup_github_ssh() {
  echo -n "Please enter your GitHub email (associated with your GitHub account): "
  read github_email

  if [ -z "$github_email" ]; then
    echo "GitHub email is required. Exiting..."
    exit 1
  fi

  # Directory and filename to store the SSH key
  ssh_key_path="$HOME/.ssh/id_rsa_github"

  # Check if the key already exists, otherwise create a new one
  if [[ -f "$ssh_key_path" ]]; then
    echo "SSH key already exists at $ssh_key_path"
  else
    # Create a new SSH key with the provided email
    ssh-keygen -t rsa -b 4096 -C "$github_email" -f "$ssh_key_path" -N ""
    echo "SSH key generated at $ssh_key_path"
  fi

  # Add the key to the SSH agent
  eval "$(ssh-agent -s)"
  ssh-add "$ssh_key_path"

  # Copy the public key to the clipboard
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cat "${ssh_key_path}.pub" | xclip -selection clipboard
  else
    pbcopy < "${ssh_key_path}.pub"
  fi

  echo "Your SSH public key has been copied to the clipboard."

  # Open the browser to the GitHub SSH settings page
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "https://github.com/settings/ssh/new"
  else
    open "https://github.com/settings/ssh/new"
  fi

  echo "Please add your SSH key to GitHub."
}

# Check if the SSH key file already exists, otherwise inform the user and suggest setup
if [[ ! -f "$HOME/.ssh/id_rsa_github" ]]; then
  echo "GitHub SSH key not found. Use setup_github_ssh to configure."
fi
