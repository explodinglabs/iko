Login and extract the access_token from the Set-Cookie header:

```sh
export ACCESS_TOKEN=$(curl -i --silent -H "Content-Type: application/json" http://localhost/rpc/login --data '{"user_": "demo", "pass": "demo"}' |sed -nE 's/^Set-Cookie: access_token=([^;]*).*/\1/p')
```

Get the refresh token inserted when logged in:

```sh
export REFRESH_TOKEN=$(docker exec postgres psql -U postgres -d sp -Atc "select token from auth.refresh_token order by created_at desc limit 1")
```

Refresh the access token and extract the new token from the Set-Cookie header:

```sh
export ACCESS_TOKEN=$(curl --silent -i -X POST -H 'Cookie: refresh_token='$REFRESH_TOKEN'; HttpOnly' http://localhost/rpc/refresh_token |sed -nE 's/^Set-Cookie: access_token=([^;]*).*/\1/p')
```
