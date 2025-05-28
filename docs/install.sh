#!/bin/sh

set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
WRAPPER="$INSTALL_DIR/iko"

mkdir -p "$INSTALL_DIR"

cat > "$WRAPPER" <<'EOF'
#!/bin/sh

if [ -f .env ]; then
  docker run --rm -it \
    --env-file .env \
    -v "${PWD}/migrations:/repo:rw" \
    -v "${PWD}/scripts:/scripts:ro" \
    ghcr.io/explodinglabs/iko:0.1.0 "$@"
else
  docker run --rm -it \
    -v "${PWD}/migrations:/repo:rw" \
    -v "${PWD}/scripts:/scripts:ro" \
    ghcr.io/explodinglabs/iko:0.1.0 "$@"
fi
EOF

chmod +x "$WRAPPER"

if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  echo "✅ Installed iko to $WRAPPER"
  echo "⚠️  Warning: $INSTALL_DIR is not in your PATH. Add this to your shell profile:"
  echo 'export PATH="$HOME/.local/bin:$PATH"'
else
  echo "✅ Installed iko. You can now run: iko"
fi
