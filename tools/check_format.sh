#!/bin/bash
set -e
echo 'Checking formatting...'
EC_COUNT=0
for file in $(find . -type f -name '*.py' -o -name '*.rs' -o -name '*.ts' -o -name '*.js' -o -name '*.go' -o -name '*.json' -o -name '*.md' -o -name '*.yml' -o -name '*.yaml' | grep -v node_modules | grep -v .git); do
    case "$file" in
        *.py|*.rs) [ "$(head -1 "$file" | cat -A | grep -o '\$' | wc -l)" -gt 0 ] && echo "CRLF: $file" && EC_COUNT=$((EC_COUNT+1)) ;;
        *.ts|*.js|*.json|*.md|*.yml|*.yaml) [ -n "$(tail -c1 "$file")" ] && EC_COUNT=$((EC_COUNT+1)) ;;
        *.go) grep -q ' ' "$file" && echo "Space indent in Go: $file" && EC_COUNT=$((EC_COUNT+1)) ;;
    esac
done
if [ $EC_COUNT -gt 0 ]; then echo "$EC_COUNT formatting issue(s) found"; exit 1; fi
echo 'All formatting checks passed'
