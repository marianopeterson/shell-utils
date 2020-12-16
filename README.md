# shell-utils

A collection of helpful shell utilities including shell functions and commands to configure MacOS system settings from the shell.

# Installation

1. Season MacOS to taste by manually selecting and executing the commands from `mac-preferences.sh` that you like.

2. Copy or link the `shell-functions` directory to `~/.shell-functions`.


3. Add this to `~/.bash_profile`:

    ```bash
    for f in "${HOME}"/.shell-functions/*; do
        include "$f"
    done   
    ```

