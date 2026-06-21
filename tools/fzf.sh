#!/bin/bash

echo "Installing fzf"

# Check if fzf is already cloned, remove if present to allow re-install
if [ -d ~/.fzf ]; then
    echo "Existing ~/.fzf directory found. Removing before reinstall."
    rm -rf ~/.fzf
fi

# Clone the fzf repo (shallow clone, no sudo required)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
if [ $? -ne 0 ]; then
    echo "git clone failed. Exiting."
    exit 1
fi

# Run the bundled installer, binary only (no shell config changes, no key bindings)
~/.fzf/install --bin --no-update-rc --no-key-bindings --no-completion
if [ $? -ne 0 ]; then
    echo "fzf install script failed. Exiting."
    exit 1
fi

# Confirm the binary actually exists where expected
if [ ! -x ~/.fzf/bin/fzf ]; then
    echo "fzf binary not found at ~/.fzf/bin/fzf after install. Exiting."
    exit 1
fi

# Success message
echo "fzf installed successfully!"
echo "checking version"
~/.fzf/bin/fzf --version