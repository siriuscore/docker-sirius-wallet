# Sirius Wallet

Docker alpine sirius wallet with the ability to stake and resume on reboot.

### New Wallet
1. Make a directory to persist wallet
    * `mkdir /path/to/sirius`
2. Start docker to create wallet
    * `docker run -d -v /path/to/sirius:/root/.sirius --restart=always --name=sirius-wallet clutteredcode/sirius-wallet:0.3`
3. Encrypt wallet
    * `docker exec -it sirius-wallet sirius-cli encryptwallet {PASSPHRASE}`
4. Backup wallet (Don't run in container)
    * `cp -p /path/to/sirius/wallet.dat /path/to/backup/sirius-wallet.dat`
5. Store passphrase somewhere so you don't forget it

### Restore Wallet
1. Make a directory to persist wallet
    * `mkdir /path/to/sirius`
2. Put wallet.dat backup in directory
    * `cp -p /path/to/backup/sirius-wallet.dat /path/to/sirius/wallet.dat`
3. Start docker to run wallet
    * `docker run -d -v /path/to/sirius:/root/.sirius --restart=always --name=sirius-wallet clutteredcode/sirius-wallet:0.3`

### Stake Wallet
1. Remove any running sirius wallet
    * `docker rm sirius-wallet -f`
2. Start wallet with staking variables
    * `docker run -d -e STAKING=true -e PASSPHRASE={PASSPHRASE} -v /path/to/sirius:/root/.sirius --restart=always --name=sirius-wallet clutteredcode/sirius-wallet:0.3`

Staking is delayed 10 seconds to ensure siriusd is running

**This will begin staking on system boot**

### Execute Commands
```bash
docker exec -it sirius-wallet sirius-cli getinfo
docker exec -it sirius-wallet sirius-cli getstakinginfo
```

 ##### Watch Staking activity
```bash
watch "docker exec -it sirius-wallet sirius-cli getstakinginfo && docker exec -it sirius-wallet sirius-cli getwalletinfo"
```