<p align="center">
  <img alt="Iko logo" height="150" src="https://github.com/explodinglabs/iko/blob/main/images/logo-light.png?raw=true#gh-light-mode-only" />
  <img alt="Iko logo" height="150" src="https://github.com/explodinglabs/iko/blob/main/images/logo-dark.png?raw=true#gh-dark-mode-only" />
</p>

<h1 align="center">
  ikō
</h1>

**Iko** (_ee-koh_) is a lightweight command-line tool for managing
**Postgres database migrations.**

It wraps [Sqitch](https://sqitch.org/) with a developer-friendly
[DSL](https://www.explodinglabs.com/iko/commands/) and
[scripting](https://www.explodinglabs.com/iko/scripting/).

https://github.com/user-attachments/assets/9dcc4ffe-f142-4bd2-aca5-8ea8bc90f712

## ❤️ Why Iko?

- Reliable, clean migrations
- Batteries-included: _deploy, verify, revert_
- Works inside a container — zero local deps
- Powerful scripting model with Bash

## 🚀 Quick Start

```sh
curl -fsSL https://explodinglabs.com/iko/install.sh | sh
echo 'SQITCH_TARGET=db:pg://postgres:postgres@localhost/app' > .env
iko init myapp
iko create_schema api
iko deploy
```

## 📚 Full Documentation

👉 [explodinglabs.com/iko/](https://explodinglabs.com/iko/)
