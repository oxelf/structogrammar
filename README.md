# Structogrammar


## Development
```bash
git clone
cd structogrammar
go get
go build -o bin/structogrammar ./cli/ && ./bin/structogrammar -html=out.html test.cpp main
```

There's a github workflow in `.github/workflows` that runs the build on a tag push.

To trigger it, just do a little
```bash
git tag -a v0.0.1 -m "v0.0.1" && git push origin v0.0.1
```
