# shell-utils

A collection of helpful shell utilities including shell functions and commands to configure MacOS system settings from the shell.

# Installation

1. Copy or link the `shell-functions` directory to `~/.shell-functions`.


2. Add this to `~/.bash_profile`:
    
    ```bash
    for f in "${HOME}"/.shell-functions/*; do
        include "$f"
    done   
    ```

