# Aristotle HPC Spack Stack

This repo contains Spack configurations and environment specifications for installing the Aristotle HPC Cluster spack-based software stack.

## Repo organization

All spack yaml configuration files are located in the `envs/` directory. The file `envs/main.yaml`, as well as files under `envs/common` contain configuration that is horizontally applied to all environments. Each subdirectory `envs/{{ env }}/` specifies an additional environment, with env-specific compilers specs and configuration overrides.

This repo is designed to produce self contained installations.
Spack itself, the installed packages, caches and modulefiles are placed in the `spack`, `site`, `lmod` and `cache` directories, upon installation but are `.gitignore`'d.

## Spack operations reference

### Spack installation managment

#### Ensure the latest spack version is installed

To download and use the latest spack version run the following script.

```console
# ./update_spack.sh
```

Each spack version is installed in an independent directory, and access to the latest version is done through the `spack` directory symlink.

#### Use the latest spack version

To load spack into your environment run

```console
# source ./spack/share/spack/setup-env.sh
```

Check that you have loaded spack with

```console
# spack --version
```

#### Update the builtin repo

To fetch the latest package recipes from the upstream `builtin` spack repo, run

```console
spack repo update
```

### Spack Environment Management

Compilers are installed in platform environments, which uses platform compilers.

User software may be installed under specific per-compiler and per-architecture environments.

#### Create environment

Create a new environment to specify a distinct software tree

```console
spack env create -d ./envs/{{ environment_name }} --without-view
```

#### Run spack commands inside a spack environment

```console
spack -d -e ./envs/{{ environment_name }} ...
```

e.g. 

```console
spack -e ./envs/{{ environment_name }} config blame modules
```

#### Concretize environment

```console
# spack -e ./envs/{{ environment_name }} concretize -Uf -j32
# # ... or ...
# srun -p {{ partition }} -c {{ ncpus }} --pty spack -e ./envs/{{ environment_name }} concretize -Uf -j {{ ncpus }}
```

#### Install packages

```console
# spack -e ./envs/{{ environment_name }} install -j32
# # ... or ...
# srun -p {{ partition }} -c {{ ncpus }} --pty spack -e ./envs/gcc-15.2.0 install -Uf -j {{ ncpus }}
```
