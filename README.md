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
spack repo update builtin
```

### Recommended spack workflow

Let's say that we want to install a package `cmake` under gcc version 15.2.0.

1. First, we locate the relevant environment. In this case it is `./envs/linux-gnu15.2.0-x86_64`
2. We check how the environment would solve the package with `spack -e ./envs/linux-gnu15.2.0-x86_64/ spec -lI cmake`
3. If in step 2 the resulting spec is not right, we play with variants and dependencies until we arrive at the desired spec. Often, the spec modifier (e.g. variant) is useful horizontally and it might be more appropriate to specify in the `packages.yaml` common configuration.
4. After we arrive at the desired spec, we add it to the environment, reconcretize and install.
	* First, we try
		```console
		$ spack -e ./envs/linux-gnu15.2.0-x86_64/ install --add cmake
		```
	* It might not work because it requires `concretize --force` to run first. In such a case we run
		```console
		$ spack -e ./envs/linux-gnu15.2.0-x86_64/ add cmake
                $ spack -e ./envs/linux-gnu15.2.0-x86_64/ concretize --force
		```
	* Assuming the concretization goes well, we can install
		```console
                $ spack -e ./envs/linux-gnu15.2.0-x86_64/ install
                ```

### Override Spack Package Recipes

In addition to the "upstream" package repo for Spack (the `builtin` repo), in this repo there is an additional package repo named `aristotle`, that is injected by default in the environments configuration.

This repo can be used whenever there is a need to override a Spack package for the site installation of Aristotle.

Packages included in this repo will be chosen with priority compared to builtin packages. In order to modify an existing recipe, the recipe files can be copied as-is from the builtin repo in the aristotle repo and subsequently customizations can be made.

Example:

```
$ spack repo ls 
[+] builtin    v2.2    ~/.spack/package_repos/fncqgg4/repos/spack_repo/builtin
$ cp -r ~/.spack/package_repos/fncqgg4/repos/spack_repo/builtin/packages/{{ pkg_name }} repos/spack_repo/aristotle/packages/{{ pkg_name }}
```

### Spack Environment Management Reference

Compilers are installed in platform environments, which uses platform compilers.

User software may be installed under specific per-compiler and per-architecture environments.

The platform environment names have the format `linux-{{ distribution }}-{{ arch }}` (e.g. `linux-rocky9-x86_64`), whereas the per-compiler environments have the format `linux-{{ compiler-type }}{{ compiler-version }}-{{ arch }}` (e.g. `linux-gnu15.2.0-x86_64`).

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
