To run the tests:

```sh
rm -rf migrations && iko init --target postgres://user:pass@localhost:5432/app myapp && cp test/test.sh migrations/ && iko bash test.sh | tee >(sed -r "s/\x1B\[[0-9;]*[mK]//g" > test/out) && diff test/expected test/out && diff -r -x sqitch.plan test/migrations migrations
```
