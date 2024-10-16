# Dotfiles

This repository contains my personal configuration files (dotfiles) for various applications and tools. These dotfiles help to set up a consistent development environment across different machines.

## Installation

To clone the repository and set up the configuration, follow these steps:

1. **Clone the repository:**

    ```sh
    git clone https://github.com/morissonmaciel/Dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ```

2. **Run the setup script:**

    ```sh
    ./setup.sh
    ```

Alternatively, you can download and run the setup script directly using `curl`:

  ```sh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/morissonmaciel/Dotfiles/main/setup.sh)"
  ```

This will create symlinks for the dotfiles in your home directory and install any necessary dependencies.

## Customization

Feel free to customize the dotfiles to suit your needs. You can edit the files directly in the repository and re-run the setup script to apply the changes.

## Contributing

If you have any improvements or suggestions, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License.
