#!/bin/bash

LATEST_SPACK_VERSION=$(
    # List availabe spack tags
    # Filter for production version tags
    # Isolate version numbers
    # Keep the last one
    git ls-remote --tags https://github.com/spack/spack.git \
    | grep -E 'refs/tags/v[0-9]\.[0-9]+\.[0-9]$' \
    | sed 's|.*refs/tags/||' \
    | tail -n 1
)

echo Latest available spack version: ${LATEST_SPACK_VERSION}

_SPACK_VERSION="${LATEST_SPACK_VERSION}"
_SPACK_DIRECTORY="spack-${_SPACK_VERSION}"
_SYMLINK_DIRECTORY="spack"

[[ ! -d "${_SPACK_DIRECTORY}" ]] && {
    echo "Cloning spack into ${_SPACK_DIRECTORY}" \
    && git clone --depth=1 -b "${_SPACK_VERSION}" -c feature.manyFiles=true https://github.com/spack/spack.git "${_SPACK_DIRECTORY}" \
    && echo Updating spack symlink \
    && [[ -L "${_SYMLINK_DIRECTORY}" ]] && rm "${_SYMLINK_DIRECTORY}" \
    && ln -s "${_SPACK_DIRECTORY}" "${_SYMLINK_DIRECTORY}" \
    && echo Done
} || {
    echo The latest available spack version is already present
}
