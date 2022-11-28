# Docker images for creating release builds

This Docker image is used to create release binaries for Github Actions. To build locally, use the following `make` command:

`make distclean build-reproducible`

This will build the build release binaries into `. /artifact`.
