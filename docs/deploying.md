# 🚀 Deploying Migrations to Remote Environments

Iko runs inside a container, so to deploy migrations to a remote environment
(like staging or production), you’ll need to include your migration scripts
inside a custom Docker image.

This guide explains how to build and use that image.

---

## ✅ Why use a custom image?

The standard Iko CLI uses `docker run` with a local `migrations/` directory mounted into the container. This works great locally, but in remote environments:

- There's no local `migrations/` directory to mount.
- There’s no Git repository cloned.
- You want repeatable, portable deploys — not manual file copying.

By building a Docker image that _includes_ your migrations, you ensure the container is fully self-contained and deployable anywhere.

---

## 🧱 Step-by-Step: Build and Deploy

### 1. Create a Dockerfile

In the root of your project, add a `Dockerfile` like this:

```Dockerfile
FROM ghcr.io/explodinglabs/iko:0.1.0
COPY migrations /repo
```

This copies your migrations into the image at /repo, where Iko expects them.

### 2. Build the image

Give it a meaningful tag, e.g. for production:

```sh
docker build -t ghcr.io/your-org/iko-with-migrations:latest .
```

Then push it to your container registry:

```sh
docker push ghcr.io/your-org/iko-with-migrations:latest
```

### 3. Run the deploy on the remote environment

On the target server or inside your CI/CD pipeline, run:

```sh
docker run --rm \
 -e PG_URI=pg://user:pass@postgres/app \
 ghcr.io/your-org/iko-with-migrations:latest deploy --verify
```
