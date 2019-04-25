[Sirius](https://getsirius.io) Docker Wallet Features:

 * The fastest and most compact way to run a wallet
 * Automatic startup and staking on system reboot
 * container image size: ~45MB

Find us at:
* [Slack](https://slack.getsirius.io)
* [Discord](https://discord.getsirius.io)
* [Telegram](https://telegram.getsirius.io/)

# [siriuscore/sirius-wallet](https://github.com/siriuscore/docker-sirius-wallet)

[Sirius](https://getsirius.io) is a next-generation smart contract platform based on Bitcoin and Ethereum's EVM.

**Donate Sirius:** SgodXRRCJLRuj1S8RW5wABzjdDRyFGR2W1

## First Run Requirement - Securing Wallet
after you start a **NEW** wallet for the first time run the following to manually set the passphrase:

```docker exec -it sirius-wallet sirius-cli encryptwallet <YOUR_PASSPHRASE>```

## Usage

Here are some example snippets to help you get started creating a container.

### docker
```
docker run \
  -d \
  --name=sirius-wallet \
  -e STAKING=true \
  -e PASSPHRASE=<YOUR_PASSPHRASE> \
  -v <path/to/sirius>:/root/.sirius \
  --restart always \
  siriuscore/sirius-wallet
```

### docker-compose

Compatible with docker-compose v3.7 schemas.
```
version: '3.7'

services:
  sirius-wallet:
    image: siriuscore/sirius-wallet
    container_name: sirius-wallet
    environment:
      STAKING: 'true'
      PASSPHRASE: <YOUR_PASSPHRASE>
    volumes:
      - <path/to/sirius>:/root/.sirius
    restart: always
```


## Required Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively.

For example, `-v /home/user/sirius-wallet:/root/.sirius` would bind the `/root/.sirius` directory inside the container to the `/home/user/sirius-wallet` directory on the host, outside the container.

| Parameter | Function |
| :----: | --- |
| `-v /root/.sirius` | location to persist wallet data |

*This is where a wallet.dat will be generated or consumed*

**wallet.dat** should be saved after it is generated to an external location for wallet recovery


## Optional Parameters

**ONLY USE AFTER PASSPHRASE MANUALLY SET AS DESCRIBED ABOVE**

| Parameter | Function | Default |
| :----: | --- | :----: |
| `-e STAKING=true` | if you want the wallet to stake | false |
| `-e PASSPHRASE=<YOUR_PASSPHRASE>` | passphrase used to secure the wallet, **Should always provided** | '' |

*Special note* - If `STAKING=true` a `PASSPHRASE` must also be specified


## Support Info

* Shell access whilst the container is running
  * `docker exec -it sirius-wallet /bin/ash`
* To monitor the logs of the container in realtime
  * `docker logs -f sirius-wallet`
* Wallet commands
  * `docker exec -it sirius-wallet sirius-cli getinfo`
  * `docker exec -it sirius-wallet sirius-cli getstakinginfo`
  * `docker exec -it sirius-wallet sirius-cli getaddressesbyaccount ""`
* Watch staking activity
  * `watch "docker exec -it sirius-wallet sirius-cli getstakinginfo && docker exec -it sirius-wallet sirius-cli getwalletinfo"`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' sirius-wallet`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' siriuscore/sirius-wallet`


## Updating Info 
  
Below are the instructions for updating containers:  
  
### Via Docker Run
* Update the image: `docker pull siriuscore/sirius-wallet`
* Stop the running container: `docker stop sirius-wallet`
* Delete the container: `docker rm sirius-wallet`
* Run a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/root/.sirius` folder and settings will be preserved)
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull sirius-wallet`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d sirius-wallet`
* You can also remove the old dangling images: `docker image prune`
