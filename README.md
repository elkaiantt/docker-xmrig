Build individual targets:
  - docker build --target build --tag xmrig .
  - docker build --tag xmrig .

Config generator:
  - https://config.xmrig.com/

Start container:

    docker run \
      --restart unless-stopped \
      --cpu-shares 512 \
      --publish 8080:80 \
      xmrig
