# navigation
PS1='> '

# Imports
for file in /home/omelkonian/git/.dotfiles/bash/*.symlink; do
    if [[ $file != *"controls"* ]]; then
      . $file
    fi
done
