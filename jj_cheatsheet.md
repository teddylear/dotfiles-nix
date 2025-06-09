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

# TODO:
- merging branches locally
- updating branches from remote
- rebasing branches
- squash example
- editing middle commit example
- workspaces?
- rebasing from upstream
