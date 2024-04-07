# See directories about tasks

## First task about Grafana, Prometheus and firing Mem Alert

## Up and Running

```sh
docker-compose up # -d
```

## Second task about up and running GitLab with GitLab Runner

Sample runner configuration `config.toml` at `/etc/gitlab-runner/`:

+ Install `gitlab-runner` locally or using docker image of that
  + In case of docker image: `docker exec -it gitlab-runner bash`
  + Enter new token and host name that you got them from GitLab runner page (IP
    network address or you can ignore it by `network_mode: host`) at
    `docker-compose`
+ Copy this config and paste it into `/etc/gitlab-runner/config.toml`
+ Check token and url from following config and your GitLab runner configuration
  (Through the UI)
+ Please note that when you put your localhost address you may use `127.0.0.1`
  or `localhost` address, these addresses can cause new issue about **repository
  access permission** from GitLab-runner to the repo that created new
  `.gitlab-ci.yml` CI/CD workflow. So to fix this issue, instead of using
  localhost or 127.0.0.1 use local machine ip address (For my issue, my ip is
  192.168.1.140) in both GitLab-runner toml config and docker-compose GitLab
  setup. See more at [stack overflow](https://stackoverflow.com/questions/34003101/gitlab-runner-unable-to-clone-repository-via-http)

```toml
concurrent = 1
check_interval = 0
shutdown_timeout = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "Ruby image runner"
  url = "http://192.168.1.140"
  id = 1
  token = "glrt-gAQd8hdsQ9BFQ6xCyUnq"
  token_obtained_at = 2024-04-03T13:41:21Z
  token_expires_at = 0001-01-01T00:00:00Z
  executor = "docker"
  [runners.cache]
    MaxUploadedArchiveSize = 0
  [runners.docker]
    tls_verify = false
    image = "ruby:2.7"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
    network_mtu = 0

[[runners]]
  name = "Python image runner"
  url = "http://192.168.1.140"
  id = 2
  token = "glrt-gAQd8hdsQ9BFQ6xCyUnq"
  token_obtained_at = 2024-04-03T13:41:21Z
  token_expires_at = 0001-01-01T00:00:00Z
  executor = "docker"
  [runners.cache]
    MaxUploadedArchiveSize = 0
  [runners.docker]
    tls_verify = false
    image = "python:3.11"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
    network_mtu = 0
```

### Sample CI at GitLab Pipeline to run Python app

```yml
stages:
  - test

test_job:
  stage: test
  script:
    - python -V
    - python main.py
```

## Improve GitLab Runner config

You can use only one linux, mac or windows machine at runner config instead of
define every image separately. After that you will need image name at your
`.gitlab-ci.yml`.

```diff
concurrent = 1
check_interval = 0
shutdown_timeout = 0

[session_server]
  session_timeout = 1800

- [[runners]]
-   name = "Ruby image runner"
-   url = "http://192.168.1.140"
-   id = 1
-   token = "glrt-gAQd8hdsQ9BFQ6xCyUnq"
-   token_obtained_at = 2024-04-03T13:41:21Z
-   token_expires_at = 0001-01-01T00:00:00Z
-   executor = "docker"
-   [runners.cache]
-     MaxUploadedArchiveSize = 0
-   [runners.docker]
-     tls_verify = false
-     image = "ruby:2.7"
-     privileged = false
-     disable_entrypoint_overwrite = false
-     oom_kill_disable = false
-     disable_cache = false
-     volumes = ["/cache"]
-     shm_size = 0
-     network_mtu = 0

- [[runners]]
-   name = "Python image runner"
-   url = "http://192.168.1.140"
-   id = 2
-   token = "glrt-gAQd8hdsQ9BFQ6xCyUnq"
-   token_obtained_at = 2024-04-03T13:41:21Z
-   token_expires_at = 0001-01-01T00:00:00Z
-   executor = "docker"
-   [runners.cache]
-     MaxUploadedArchiveSize = 0
-   [runners.docker]
-     tls_verify = false
-     image = "python:3.11"
-     privileged = false
-     disable_entrypoint_overwrite = false
-     oom_kill_disable = false
-     disable_cache = false
-     volumes = ["/cache"]
-     shm_size = 0
-     network_mtu = 0

+ [[runners]]
+   name = "Alpine runner"
+   url = "http://192.168.1.140"
+   id = 1
+   token = "glrt-gAQd8hdsQ9BFQ6xCyUnq"
+   token_obtained_at = 2024-04-03T13:41:21Z
+   token_expires_at = 0001-01-01T00:00:00Z
+   executor = "docker"
+   [runners.cache]
+     MaxUploadedArchiveSize = 0
+   [runners.docker]
+     tls_verify = false
+     image = "alpine:latest"
+     privileged = false
+     disable_entrypoint_overwrite = false
+     oom_kill_disable = false
+     disable_cache = false
+     volumes = ["/cache"]
+     shm_size = 0
+     network_mtu = 0
```

Also edit `.gitlab-ci.yml` config like following:

```yml
stages:
  - dev 

dev_job:
  stage: dev 
  image: python:latest # Here
  script:
    - python -V
    - python main.py
```