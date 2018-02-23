# Sirius Wallet

### Create new wallet
```bash
docker run -d -v /path/to/sirius:/root/.sirius --restart=always --name sirius-wallet clutteredcode/sirius-wallet
```
**Don't forget to save a backup of /path/to/sirius/wallet.dat**

### Wallet with existing backup
```bash
docker run -d -e STAKING=true -e PASSWORD=****** -v /path/to/sirius/wallet.dat:/root/.sirius/wallet.dat --restart=always --name sirius-wallet clutteredcode/sirius-wallet
```

### Execute commands on docker container
```bash
docker exec -it sirius-wallet sirius-cli getinfo
docker exec -it sirius-wallet sirius-cli getstakinginfo
```
