# Sirius Wallet

[Sirius Docker Hub](https://hub.docker.com/r/siriuscore/sirius-wallet)

[Sirius Homepage](https://getsirius.io)


Docker alpine sirius wallet with the ability to stake and resume on reboot.

**Donate Sirius:** SgodXRRCJLRuj1S8RW5wABzjdDRyFGR2W1

### New Wallet
1. Make a directory to persist wallet
    * `mkdir /path/to/sirius`
2. Start docker to create wallet
    * `docker run -d -v /path/to/sirius:/root/.sirius --restart=always --name=sirius-wallet siriuscore/sirius-wallet`
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
    * `docker run -d -v /path/to/sirius:/root/.sirius --restart=always --name=sirius-wallet siriuscore/sirius-wallet`

### Stake Wallet (Manual)
1. Run staking command
    * ```bash
      docker exec -it sirius-wallet sirius-cli -stdin walletpassphrase
      [type password and hit enter]
      [type time to remain unlocked and hit enter]
      true
      [Press CTRL+D to complete the input sequence]
      ```

**This must the done everytime the container is restarted (ie. system boot)**

### Stake Wallet (Automatic) - password visible in docker container
1. Remove any running sirius wallet
    * `docker rm sirius-wallet -f`
2. Start wallet with staking variables
    * `docker run -d -e STAKING=true -e PASSPHRASE={PASSPHRASE} -v /path/to/sirius:/root/.sirius --restart=always --name=sirius-wallet siriuscore/sirius-wallet`

Staking is delayed 10 seconds to ensure siriusd is running

**This will begin staking on container start (ie. system boot)**

### Execute Commands
```bash
docker exec -it sirius-wallet sirius-cli getinfo
docker exec -it sirius-wallet sirius-cli getstakinginfo
docker exec -it sirius-wallet sirius-cli getaddressesbyaccount ""
```

 ##### Watch Staking activity
```bash
watch "docker exec -it sirius-wallet sirius-cli getstakinginfo && docker exec -it sirius-wallet sirius-cli getwalletinfo"
```
