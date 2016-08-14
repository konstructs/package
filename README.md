# Package

A collection of script to build and package the server, API and official plugins.

## Get all JARs

Type `make extract`, this will build all repositories and plugins specified under `PLUGINS` and `REPOS` in `Makefile`.

The resulting JARs will be placed in `out/`. This build both the latest SNAPSHOT (master) and the latest release (tag).

