#!/bin/bash
# Install git hooks

ln -s -f $(pwd)/git-hooks/pre-commit $(pwd)/.git/hooks/pre-commit
chmod +x $(pwd)/.git/hooks/pre-commit
