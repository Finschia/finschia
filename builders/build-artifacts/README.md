# Docker images for creating release builds

This Docker image is used to create release binaries for Github Actions. To build locally, build the following
`lbm/build-artifacts` image and run `make` command:

```shell
% cd builders/build-artifacts
% docker build -t lbm/build-artifacts .
% cd ../..
% make distclean build-reproducible
```

This will build the build release binaries into `. /artifact`.
