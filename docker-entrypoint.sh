#!/bin/bash
set -e

# Remove um arquivo de lock do servidor Rails
if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

# Executa o comando principal (CMD)
exec "$@"