#!/bin/sh
set -e

echo
exec "$@"

if [ "$1" = "siriusd" ] && [ "${STAKING,,}" == "true" ]; then
    echo "STAKING"
fi