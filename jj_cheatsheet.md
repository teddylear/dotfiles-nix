# JJ cheatsheet

## Create a new branch at current commit
```fish
jj bookmark create <name> -r @
```

## Push new branch
```fish
jj git push --allow-new --remote origin
```

## Pull main and set main local to main remote
```fish
jj git fetch
jj bookmark set main -r main@origin
```

## Example of squashing
For something like below
```fish
 > jj
@  upruuqvv 20077627+teddylear@users.noreply.github.com 2025-06-11 20:03:46 b48c6839
│  add c.txt for chungy
○  wwszptyo 20077627+teddylear@users.noreply.github.com 2025-06-11 20:03:02 git_head() 56cb2b7a
│  Add b.txt
○  lztwuums 20077627+teddylear@users.noreply.github.com 2025-06-11 20:02:50 test-squash-jj 0900e4a3
│  touch a.txt
◆  ysxkytwz 20077627+teddylear@users.noreply.github.com 2025-06-11 19:43:51 main f608f79a
│  just format
```

To merge file texts together (note abbreviations are being used):
```fish
jj squash -f lz..u --into lz
```

# TODO:
- merging branches locally
- updating branches from remote
- rebasing branches
- squash example
- editing middle commit example
- workspaces?
- rebasing from upstream
