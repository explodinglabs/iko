To run the tests:

```sh
rm -rf migrations ~/data/myapp; docker restart postgres; iko init myapp && cp tests/test.sh migrations/ && iko bash test.sh | tee >(sed -r "s/\x1B\[[0-9;]*[mK]//g" > tests/out) && diff tests/expected tests/out && diff -r -x sqitch.plan tests/migrations migrations && iko deploy && iko verify && iko revert -y
```
