# z-bash
light-weight bash script for ps1 and alias, inspired by zsh

## Features

- zsh alias (considered git completion)
- cd stack
- config up and down arrow key for history look up
- both agnoster and plain prompt available

## Install

```bash
git clone https://github.com/AllanChain/z-bash ~/.z-bash
```
And put following lines in your `.bashrc`
```bash
Z_BASH_STYLE=agnoster # Optional, omitting this line means using plain prompt
. ~/.z-bash/z-bash.sh
```
