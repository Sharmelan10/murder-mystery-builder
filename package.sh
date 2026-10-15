#!/usr/bin/env bash
# Builds dist/murder-mystery-builder.zip: the skill folder, ready to upload to
# Claude (Settings > Capabilities > Skills) or unzip into ~/.claude/skills/.
set -euo pipefail
cd "$(dirname "$0")"
rm -f dist/murder-mystery-builder.zip
mkdir -p dist
zip -rq dist/murder-mystery-builder.zip murder-mystery-builder \
  -x "*/artifact.html" "*/standalone.html" "*/__pycache__/*" "*.DS_Store"
echo "Wrote dist/murder-mystery-builder.zip"
unzip -l dist/murder-mystery-builder.zip
