# Function to colorize echo messages *****************************************************

echocc() {
    local level="$1"
    local message="$2"
    local color_code
    case "$level" in
        info)
            color_code="90"  # Gray
            ;;
        warn)
            color_code="33"  # Yellow
            ;;
        error)
            color_code="31"  # Red
            ;;
        *)
            color_code="0"   # Default
            ;;
    esac
    echo "\033[${color_code}m${message}\033[0m"
}

alias po='echocc info'
alias pe='echocc error'
alias pw='echocc warn'

# ****************************************************************************************

# Function to ask user for secret and secret description, then update ~/.dropinrc ********

# Function to check if OpenSSL is installed
check_openssl() {
    if ! command -v openssl &> /dev/null; then
        pw "OpenSSL is not installed on the system."
        po "To install it on macOS, you can use Homebrew:"
        po "1. Install Homebrew if you don't have it: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        po "2. Then, install OpenSSL: brew install openssl"
        return 1
    fi
}

set_user_secret() {
    # Check if OpenSSL is installed
    check_openssl || return 1

    local secret
    local identification
    local env_var_name
    local key_dir="$HOME/.dropinrc/secrets"
    local private_key_file="$key_dir/secrets_rsa"
    local public_key_file="$key_dir/secrets_rsa.pub"

    po "Starting the process to store a user secret."
    po "Use CTRL+C to exit at any time."

    # Create RSA key if it doesn't exist
    if [[ ! -f "$private_key_file" ]]; then
        mkdir -p "$key_dir"
        # Generate private key
        openssl genpkey -algorithm RSA -out "$private_key_file" -pkeyopt rsa_keygen_bits:2048 >/dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            pe "Error creating RSA private key."
            return 1
        fi
        pw "RSA private key created at $private_key_file"
        # Generate public key
        openssl rsa -pubout -in "$private_key_file" -out "$public_key_file" >/dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            pe "Error creating RSA public key."
            return 1
        fi
        pw "RSA public key created at $public_key_file"
    fi

    while [[ -z "$secret" ]]; do
        po "Enter the secret:"
        read -s secret
        po ""
    done

    while [[ -z "$identification" ]]; do
        po "Enter the secret identification (no spaces or special characters):"
        read identification
        po ""

        if [[ "$identification" =~ [[:space:][:punct:]] ]]; then
            pw "Identification cannot contain spaces or special characters."
            identification=""
        fi
    done

    # Encrypt the secret using OpenSSL
    encoded_secret=$(echo -n "$secret" | openssl pkeyutl -encrypt -pubin -inkey "$public_key_file" 2>/dev/null | base64)
    if [[ $? -ne 0 ]]; then
        pe "Error encrypting the secret."
        return 1
    fi
    env_var_name="USER_SECRET_$(echo "$identification" | tr '[:lower:]' '[:upper:]' | tr -d ' ')"
    echo "# $identification" >> ~/.dropinrc/zz-user-secrets.zsh
    echo "export $env_var_name=\"$encoded_secret\"" >> ~/.dropinrc/zz-user-secrets.zsh

    # Export the variable in the current session
    export $env_var_name="$encoded_secret"

    po "Secret and identification have been saved."
}

get_user_secret() {
    # Check if OpenSSL is installed
    check_openssl || return 1

    local identification="$1"
    local env_var_name
    local secret
    local private_key_file="$HOME/.dropinrc/secrets/secrets_rsa"

    # Load the secrets file
    source ~/.dropinrc/zz-user-secrets.zsh

    if [[ -z "$identification" ]]; then
        po "Enter the secret identification (no spaces or special characters):"
        read identification
        po ""

        if [[ "$identification" =~ [[:space:][:punct:]] ]]; then
            pe "Identification cannot contain spaces or special characters."
            return 1
        fi
    fi

    env_var_name="USER_SECRET_$(echo "$identification" | tr '[:lower:]' '[:upper:]' | tr -d ' ')"

    if [[ -z "$(printenv "$env_var_name")" ]]; then
        pe "User secret environment variable $env_var_name does not exist."
        return 1
    fi

    # Decrypt the secret using OpenSSL
    secret=$(printenv "$env_var_name" | base64 --decode | openssl pkeyutl -decrypt -inkey "$private_key_file" 2>/dev/null)
    if [[ $? -ne 0 ]]; then
        pe "Error decrypting the secret."
        return 1
    fi

    if [[ -z "$secret" ]]; then
        pe "No secret found for the provided environment variable."
        return 1
    fi

    echo "$secret"
}

# ****************************************************************************************
