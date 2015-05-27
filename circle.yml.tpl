machine:
  services:
    - docker

dependencies:
  cache_directories:
    - "~/docker"
  override:
    - docker info
    - if [ -e ~/docker/image.tar ]; then docker load --input ~/docker/image.tar; fi
    - docker build -t cgswong/jenkins:%%VERSION%% .
    - mkdir -p ~/docker; docker save cgswong/jenkins:%%VERSION%% > ~/docker/image.tar

test:
  override:
    - docker run -d --publish 8080:8080 --publish 50000:50000 cgswong/jenkins:%%VERSION%%; sleep 10
    - curl --retry 10 --retry-delay 5 --location --verbose http://localhost:8080

deployment:
  hub:
    branch: %%VERSION%%
    commands:
      - $DEPLOY
