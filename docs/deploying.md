# 🚀 Deploying Migrations to Remote Environments

Iko runs inside a container, so to deploy migrations to a remote environment
(like staging or production), build a custom Docker image containing your
migration scripts.

This guide explains how to build and use that image.

---

## ✅ Why use a custom image?

The standard Iko CLI uses `docker run` with a local `migrations/` directory
mounted into the container. This works great locally, but in remote
environments:

- There's no local `migrations/` directory to mount.
- There’s no Git repository cloned.
- You want repeatable, portable deploys — not manual file copying.

By building a Docker image that _includes_ your migrations, you ensure the
container is fully self-contained and deployable anywhere.

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
docker build -t ghcr.io/<org>/iko-<project>:latest .
```

Then push it to your container registry:

```sh
docker push ghcr.io/your-org/iko-<project>:latest
```

### 3. Set the target connection

Iko uses the `SQITCH_TARGET` environment variable to connect to your database.

For example:

```sh
export SQITCH_TARGET=db:pg://admin:secret@your-database-host/app
```

Alternatively, set it in your CI/CD system’s environment configuration.

> 🛡️ Do not hardcode credentials into your Dockerfile or image. Use CI secrets
> or -e flags instead.

### 4. Run the deployment

From your CI/CD pipeline or target server, run:

```sh
docker run --rm ghcr.io/your-org/iko-your-project:latest deploy --verify
```

#### 🤔 Do I need --network?

Only if your Postgres instance is running in Docker on the same machine.

If so, and it's in a custom Docker network, use:

```sh
docker run --rm \
 --network your-network \
 ghcr.io/your-org/iko-your-project:latest deploy --verify
```

Otherwise, for hosted databases (RDS, Cloud SQL, etc.) or Postgres installed on
the host system, you don’t need a custom Docker network.
