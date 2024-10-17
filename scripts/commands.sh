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

store_user_secret() {
    local secret
    local identification
    local env_var_name

    encode_secret_base64() {
        echo -n "$1" | base64
    }

    po "Starting the process to store a user secret."
    po "Use CRTL+C to exit at any time."

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

    encoded_secret=$(encode_secret_base64 "$secret")
    env_var_name="USER_SECRET_$(echo "$identification" | tr '[:lower:]' '[:upper:]' | tr -d ' ')"
    echo "# $identification" >> ~/.dropinrc/zz-user-secrets.zsh
    echo "export $env_var_name=\"$encoded_secret\"" >> ~/.dropinrc/zz-user-secrets.zsh

    po "Secret and identification have been saved."
}

get_user_secret() {
    local identification="$1"
    local env_var_name
    local secret

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

    secret=$(printenv "$env_var_name" | base64 --decode 2>/dev/null)

    if [[ -z "$secret" ]]; then
        pe "No secret found for the given environment variable."
        return 1
    fi

    echo "$secret"
}

# ****************************************************************************************
