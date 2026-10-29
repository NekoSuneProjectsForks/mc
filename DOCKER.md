# Docker image (AMD64 and ARM64)

This fork builds the MinIO `mc` client **from this repository**, not upstream's `mc@latest`.

GitHub Actions builds `linux/amd64` and `linux/arm64`. On pushes to `master`, it publishes
`ghcr.io/nekosuneprojectsforks/mc:latest` and a commit-SHA tag. On `v*` tags, it
also publishes that version tag. Pull requests build without publishing.

## Quick start

```sh
docker run --rm ghcr.io/nekosuneprojectsforks/mc:latest --version
docker run --rm ghcr.io/nekosuneprojectsforks/mc:latest --help
```

## Persistent configuration

```sh
docker volume create mc-config
docker run --rm -it -v mc-config:/config ghcr.io/nekosuneprojectsforks/mc:latest alias set myminio https://s3.example.com ACCESS_KEY SECRET_KEY
docker run --rm -v mc-config:/config ghcr.io/nekosuneprojectsforks/mc:latest ls myminio
```

Keep credentials out of scripts, CI logs and public Compose files. The image has no S3 server; it is the S3-compatible **client**.

## Local image build

```sh
docker build -t mc-local .
docker run --rm mc-local --version
```

To test both architectures with Buildx, use `docker buildx build --platform linux/amd64,linux/arm64 .`.

The GitHub Actions workflow requires Actions to be enabled and GHCR package write permission for `GITHUB_TOKEN`. Package visibility is configured separately in GitHub after publishing.
