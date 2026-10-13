#!/bin/sh
set -eu

if [ -z "${VIRTUAL_ENV:-}" ] || [ ! -x "$VIRTUAL_ENV/bin/ruff" ]; then
    echo "Activate the development virtual environment and install the dev extra first." >&2
    exit 1
fi

HOOK=$(git rev-parse --git-path hooks/pre-commit)
if [ -e "$HOOK" ]; then
    echo "A pre-commit hook already exists at $HOOK; leaving it unchanged." >&2
    exit 1
fi

cat > "$HOOK" <<EOF
#!/bin/sh
set -e
REPO_DIR=\$(git rev-parse --show-toplevel)
cd "\$REPO_DIR"
"$VIRTUAL_ENV/bin/ruff" check .
"$VIRTUAL_ENV/bin/ruff" format --check .
EOF
chmod +x "$HOOK"
