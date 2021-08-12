// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
    platforms = [
        "linux/amd64",
        "linux/arm64",
        "linux/arm/v7",
        "linux/arm/v6",
        "linux/386",
        "linux/s390x",
        "linux/ppc64le"
    ]
}

target "2.7" {
    inherits = ["docker-metadata-action"]
    dockerfile = "Dockerfile"
    context = "./2.7/alpine3.11/"
    tags = [
        "cyb3rjak3/alpine-pypy-build:2.7-7.3.5-alpine3.11",
        "ghcr.io/cyb3r-jak3/alpine-pypy-build:2.7-7.3.5-alpine3.11"
    ]
}

target "2.7-bootstrap" {
    inherits = ["docker-metadata-action"]
    dockerfile = "bootstrap/Dockerfile"
    context = "./2.7/alpine3.11/"
    tags = [
        "cyb3rjak3/alpine-pypy-build:2.7-7.3.5-bootstrap-alpine3.11",
        "ghcr.io/cyb3r-jak3/alpine-pypy-build:2.7-7.3.5-bootstrap-alpine3.11"
    ]
}

target "3.7" {
    inherits = ["docker-metadata-action"]
    dockerfile = "Dockerfile"
    context = "./3.7/alpine3.11/"
    tags = [
        "cyb3rjak3/alpine-pypy-build:3.7-7.3.5-alpine3.11",
        "ghcr.io/cyb3r-jak3/alpine-pypy-build:3.7-7.3.5-alpine3.11"
    ]
}

target "3.7-bootstrap" {
    inherits = ["docker-metadata-action"]
    dockerfile = "bootstrap/Dockerfile"
    context = "./3.7/alpine3.11/"
    tags = [
        "cyb3rjak3/alpine-pypy-build:3.7-7.3.5-bootstrap-alpine3.11",
        "ghcr.io/cyb3r-jak3/alpine-pypy-build:3.7-7.3.5-bootstrap-alpine3.11"
    ]
}