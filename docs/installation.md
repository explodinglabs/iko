# 🚀 Installation

> ⚠️ **Iko runs inside a container,** so you'll need [Docker
> installed](https://docs.docker.com/get-docker/).

## 1. Install the development CLI with:

```sh
curl -fsSL https://explodinglabs.com/iko/install.sh | sh
```

This installs a lightweight `iko` script to `~/.local/bin` that wraps `docker run`, and (if present) loads environment variables from a `.env` file.

You can verify it’s working with:

```sh
iko version
```
