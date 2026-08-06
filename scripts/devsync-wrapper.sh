#!/bin/bash
set -e

# Start devsync in background; it will clean dist/ and rebuild
bunx @jannael/devsync build &
PID=$!

# Wait for devsync to START wiping dist (our build's CSS files disappear)
while ls dist/_astro/*.css >/dev/null 2>&1; do sleep 0.1; done

# Wait for devsync to FINISH building (its CSS files appear)
while ! ls dist/_astro/*.css >/dev/null 2>&1; do sleep 0.1; done

# Create symlink BEFORE devsync tries to inline CSS
mkdir -p dist/sarodriguezqueirolo
ln -sf ../_astro dist/sarodriguezqueirolo/_astro

# Wait for devsync to finish
wait $PID
