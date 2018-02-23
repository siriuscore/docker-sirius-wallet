#!/bin/sh
set -e

siriusd -daemon

stake=$(echo $STAKING | tr -s '[:upper:]' '[:lower:]')
if [ $stake == "true" ]; then
    if [ -z "$PASSWORD" ]; then
        echo "ERROR: PASSWORD required to stake"
        exit 1
    else
        sleep 30s
        sirius-cli walletpassphrase $PASSWORD 999999 true
        echo "wallet is staking"
    fi
fi

exec "$@"