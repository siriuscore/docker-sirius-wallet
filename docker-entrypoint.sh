#!/bin/sh
set -e

siriusd &

stake=$(echo $STAKING | tr -s '[:upper:]' '[:lower:]')
if [ $stake == "true" ]; then
    if [ -z $PASSPHRASE ]; then
        echo "ERROR: PASSPHRASE required to stake"
        exit 1
    else
        sleep 10s
        sirius-cli walletpassphrase $PASSPHRASE 999999 true
        echo "wallet is staking"
    fi
fi

wait