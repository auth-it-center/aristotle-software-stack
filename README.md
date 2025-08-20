# Aristotle HPC Spack Stack

This repo contains Spack configurations and environment specifications for installing the Aristotle HPC Cluster spack-based software stack.

## Repo organization

All spack yaml configuration files are located in the `config/` directory. The file `config/common.yaml` contains configuration that is horizontally applied to all environments. Each subdirectory `config/{{ env }}/` specifies an additional environment.

This repo is designed to produce self contained installations.
Spack itself, the installed packages, caches and modulefiles are placed in the `spack`, `site`, `lmod` and `cache` directories, upon installation but are `.gitignore`'d.

## Spack operations

### Ensure the latest spack version is installed

To download and use the latest spack version run the following script.

```console
# ./update_spack.sh
```

Each spack version is installed in an independent directory, and access to the latest version is done through the `spack` directory symlink.

### Use the latest spack version

To load spack into your environment run

```console
# source ./spack/share/spack/setup-env.sh
```

Check that you have loaded spack with

```console
# spack --version
```

### Update the builtin repo

To fetch the latest package recipes from the upstream `builtin` spack repo, run

```console
spack repo update
```

## Spack Environments

Compilers are installed in the `platform` environment, which uses the platform compiler of Rocky 9.

User software may be installed under specific compiler-platform environments.
